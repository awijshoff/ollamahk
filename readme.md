# Ollamahk

## API

The Ollama Autohotkey (v1). library's API is designed around the [Ollama REST API](https://github.com/ollama/ollama/blob/main/docs/api.md).

It leverages WinHTTP requests using JSON.ahk for conversion to JSON and back to autohotkey objects. Make sure to import the JSON.ahk file from the modules folder to your script before using Ollama.ahk to prevent errors.

## Usage

The usage is very similar to the [npm ollama package](https://www.npmjs.com/package/ollama).

You can use the library like this for Ollama:

```ahk
#Include Ollama.ahk
ollama := new ollama()
modelList := ollama.list() ; returns the models available in ollama
```

To use Ollama's OpenAI-API:

```ahk
#Include Ollama.ahk
openai := new OpenAI(host:="your-endpoint", apiKey:="dont_upload_into_repo")
modelList := openai.models() ; returns the models available in ollama
```

For more information on how you can use the library see `examples_ollama.ahk` and `examples_ollamaopenai.ahk` in this repository.

### Caveats

- The library is not yet fully tested and may not work as expected.
- Because of the way autohotkey works with bools and strings, booleans must be passed as JSON.false - params (e.g., JSON.false instead of false). Read more about the datatypes [here](https://github.com/G33kDude/cJson.ahk).
- Streaming is currently not supported, so streaming must be set to JSON.false or else the WinHTTP request will fail and throw an error.

### Todo

- [ ] Streaming support? For autohotkey no added value.
- [ ] Add ImagePut.ahk to the modules folder to convert images to base64 that can be used since ollama version 0.4.x or leave it to the user to add it in as a module to their project.
- [ ] Since streaming is not supported, the abort function cannot be implemented - maybe as a hotkey?
- [ ] If models are pulled from HuggingFace and their names contain a slash (/), then the openai-model-endpoint will 404. Consider URL encoding.
- [ ] verbose: JSON.false seems to have a bug when decoding.

### Contributions

Contributions are welcome! Feedback is also appreciated, so please feel free to create an issue or pull request if you find any bugs or want to suggest improvements.
