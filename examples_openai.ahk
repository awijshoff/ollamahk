; Example of how to use Ollama.ahk
; For reference on request and returned objects see https://github.com/ollama/ollama/blob/main/docs/openai.md

#Include Ollama.ahk ; This file contains a class to interact with Ollama API.
#Include ./modules/Json.ahk ; This file contains functions to parse JSON strings.

; Create an instance of the OpenAI class - you may pass an host and apikey to it, if not provided it will use ollama defaults.
openai := new OpenAI()

/*
Getting the list of available models
Returns all available models using the list method. modelList.models is an array of model objects.
Example: get the models and iterate over all models, showing their names in a message box
*/
modelList2 := openai.models()
for index, model in modelList2.data {
    MsgBox, 0, OpenAI, % model.id
}

/*
Sending an chat request for the first model in the list and show the resulting text. Sending a generation request will load the model.
*/
request := {model: modelList2.data[1].id, messages: [{role: "user", content: "Say this is a test."}]}
generation := openai.chatCompletions(request)
MsgBox, 0, OpenAI, % generation.choices[1].message.content

/*
Sending a completion request for the first model in the list and show the resulting text. Sending a generation request will load the model.
*/
request := {model: modelList2.data[1].id, prompt: "Say this is a test."}
generation := openai.completions(request)
MsgBox, 0, OpenAI, % generation.choices[1].text

/*
Get info about an specific model. Returns the information for the specified model using the get method. Breaks if the modelname contains a slash.
*/
modelInfo := openai.model("mistral-small:latest")
MsgBox, 0, OpenAI, % JSON.Dump(modelInfo)
