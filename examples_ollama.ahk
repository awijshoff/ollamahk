; Example of how to use Ollama.ahk
; For reference on request and returned objects see https://github.com/ollama/ollama/blob/main/docs/api.md

#Include Ollama.ahk ; This file contains a class to interact with Ollama API.
#Include ./modules/Json.ahk ; This file contains functions to parse JSON strings.

; Create an instance of the Ollama class - you may pass an host and apikey to it, if not provided it will use ollama defaults.
ollama := new Ollama()

/*
Getting the list of available models
Returns all available models using the list method. modelList.models is an array of model objects.
Example: get the models and iterate over all models, showing their names in a message box
*/
modelList := ollama.list()
for index, model in modelList.models {
    MsgBox, 0, Ollama, % model.name
}

/*
Generate a chat response using the first model in the list (1-based-indexing!). Stream is set to Json.false so it won't be streamed, setting it to true will cause an error.
The request object contains a list of messages and the name of the model to use.
The bool parameter is passed as a JSON-obj. due to autohotkey converting true to 1 and false to 0, which the api will receive as int and return an error!
Example: Send a chat request for the first model in the list and show the result. Sending a chat request will load the model. More params can be found in the api documentation.
*/
request := { model: modelList.models[1].name, messages: [{ role: "user", content: "Why is the sky blue?" }], stream: JSON.false }
response := ollama.chat(request)
MsgBox, 0, % modelList.models[1].name,  % response.message.role . ": " . response.message.content

/*
Generate a generation response using the first model in the list.
Example: Send a generation request for the first model in the list and show the result. Sending a generation request will load the model.
*/
request := { model: modelList.models[1].name, prompt: "Why is the sky blue?", stream: JSON.false, options: { temperature: 0, seed: 12345, num_predict: 50} }
generation := ollama.generate(request)
MsgBox, 0, % request.prompt, % generation.response

/*
Get the currently loaded model - this will return the first element in the models array.
*/
loadedModel := ollama.ps()
MsgBox, 0, Ollama, % "Currently loaded Model: " . loadedModel.models[1].model

/*
Show information about a specific model - careful, verbose seems to be very slow when parsing trough the json.
*/
information  :=  ollama.show({name: loadedModel.models[1].name, verbose: JSON.false})
MsgBox, 0, Ollama, % JSON.Dump(information)