# Synthesize Java code for testing

## Test Generator:

 * Describe input constraints on Java classes, the serialized instances of which we can autogenerate DFDL for 
 * Generate java code for random classes recursively generating other classes this class depends on
 * Generate java code to construct random instances of each class (including nested dependencies)

Note: [Java-Faker](https://github.com/DiUS/java-faker) and
[DataFaker](https://www.datafaker.net) are interesting for instance data
generation, but we do not care about realism 

For parametrizing the generator:

 * Specify which of the following primitive data types are allowed as fields: byte, short, int, long, float, double, boolean and char
 * Specify which non-primitive data types are allowed for fields such as String, Arrays and Classes
 * Specify distribution of facets (e.g., for strings and arrays) such as min and max cardinality
 * Are multi-dimensional arrays supported?
 * Specify whether class fields are to be included and what fraction of fields are class fields
 * Specify the complexity of generated test data classes: distribution of number and type fields at a given depth, nesting depth for fields that are classes, inheritance hierarchy breadth and depth 

## Test Runner

 * Compile the generated Java code for the class and its dependencies per parameters specified and generate a JAR file
 * Run the DFDL generator for serialized instances of the classes in the JAR) 
 * Run the instance generator, serialize, and export binary for each instance
 * Run daffodil parse/unparse to validate each generated instance against the schema for each instance save test result: errors, bin, infoset, whether parse/unparse is identity
