#!/usr/bin/python3
# Focus on the cut of the partitioned graph, collapse other nodes
#
from   argparse                  import ArgumentParser
from   networkx.drawing.nx_pydot import read_dot, write_dot
import networkx                  as     nx

def get_args():
  p = ArgumentParser(description='CLOSURE Analysis Dot Graph Cut Zoom Utility')
  p.add_argument('-f', '--infile', required=True, type=str, help='Input dot file')
  p.add_argument('-o', '--outfile', required=True, type=str, help='Output dot file')
  p.add_argument('-k', '--khops', required=False, default=1, type=int, help='Context in hops (0)')
  return p.parse_args()

def nxthop_nbrs(G,nodes):
  ret = set()
  for n in nodes: ret = ret.union(nx.all_neighbors(G,n))
  return ret

def find_green_main(G):
  nods = G.nodes(data=True)
  for x,m in nods:
    if ' main' in m['label'] and m['enclave'] == 'green': 
      return x
  return None

def find_orange_main(G):
  nods = G.nodes(data=True)
  for x,m in nods:
    if ' main' in m['label'] and m['enclave'] == 'orange': 
      return x
  return None

def main():
  args   = get_args()
  print('Options selected:')
  for x in vars(args).items(): print('  %s: %s' % x)

  print('Loading input graph: %s' % args.infile)
  G = nx.Graph(read_dot(args.infile)) 
  print('Done loading input graph: %s' % args.infile)
  print('Number of nodes:', nx.number_of_nodes(G))
  print('Number of edges:', nx.number_of_edges(G))
  
  # Get all nodes on the cut, i.e., nodes whose fillcolor is gray
  cutset = set([n for n,c in nx.get_node_attributes(G, 'fillcolor').items() if c =='gray' or c == '"gray"'])
  print('Identified cutset, %d nodes' % len(cutset))

  # Get all nodes that are within k-hops of the selected nodes and add to anodes
  count   = 0
  anodes  = cutset
  thishop = anodes
  diffhop = anodes
  while count < args.khops:
    nexthop = nxthop_nbrs(G,thishop)
    diffhop = nexthop.difference(anodes)
    anodes  = anodes.union(nexthop)
    thishop = nexthop
    count += 1

  '''
  green_main  = find_green_main(G)
  orange_main = find_orange_main(G)
  UG = G.to_undirected(reciprocal=False)
  for n in anodes:
     print(n, nx.has_path(UG, green_main, n), nx.has_path(UG, orange_main, n))
  '''

  # The abridged graph is the subgraph of G induced by the selected nodes
  AG1 = G.subgraph(anodes)
  AG  = nx.Graph(AG1)
  AG1 = None
  G   = None
  print('Computed induced subgraph')

  green_nodes = [n for n,c in nx.get_node_attributes(AG, 'side').items() if c =='"purple/purple"']
  orange_nodes = [n for n,c in nx.get_node_attributes(AG, 'side').items() if c =='"orange/orange"']
  AG.add_node('N', side='green', style='invis', shape='polygon', pos='"0,25!"')
  AG.add_node('S', side='orange', style='invis', shape='polygon', pos='"0,-25!"')

  print("purple side %d nodes, orange side %d nodes" % (len(green_nodes), len(orange_nodes)))

  for n in green_nodes:
    if not 'fillcolor' in AG.nodes[n]: nx.set_node_attributes(AG, {n: {'fillcolor': 'purple', 'style': 'filled'}})
    if n in diffhop:
      AG.add_edge('N', n, style='invis')

  for n in orange_nodes:
    if not 'fillcolor' in AG.nodes[n]: nx.set_node_attributes(AG, {n: {'fillcolor': 'orange', 'style': 'filled'}})
    if n in diffhop:
      AG.add_edge('S', n, style='invis')


  write_dot(AG, args.outfile)
  print('Done writing output graph: %s' % args.outfile)


if __name__ == '__main__':
  main()
