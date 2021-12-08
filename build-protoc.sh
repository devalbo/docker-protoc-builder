
mkdir outfiles
mkdir outfiles/nanopb
mkdir outfiles/python
mkdir outfiles/csharp
mkdir outfiles/dart

cd protofiles
../generator-bin/protoc *.proto --nanopb_out=../outfiles/nanopb --python_out=../outfiles/python --dart_out=../outfiles/dart

# --csharp_out=../outfiles/csharp

# ./generator-bin/protoc protofiles/*.proto --nanopb_out=outfiles/nanopb --python_out=../build/python --csharp_out=../build/csharp --dart_out=../build/dart -I=protofiles
