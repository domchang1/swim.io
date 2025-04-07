from flask import Flask, request, jsonify
from flask_cors import CORS
from transformers import AutoModelForCausalLM, AutoTokenizer, pipeline
import os
from dotenv import load_dotenv
from huggingface_hub import login
import torch

load_dotenv()
MODEL_NAME = "microsoft/Phi-3-mini-4k-instruct"
API_TOKEN = os.getenv("HUGGINGFACE_API_KEY")

if API_TOKEN:
    login(token=API_TOKEN)
    
app = Flask(__name__)
CORS(app)

tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
model = AutoModelForCausalLM.from_pretrained(
    MODEL_NAME,
    device_map="auto",
    torch_dtype=torch.bfloat16 if torch.cuda.is_available() else torch.float32,
    trust_remote_code=True,
)
chat_pipeline = pipeline("text-generation", model=model, tokenizer=tokenizer)

@app.route("/chat", methods=["POST"])
def chat():
    data = request.get_json()
    message = request.get('message', '')
    if not message:
        return jsonify({"error": "Message is required"}), 400
    response = prompt_chatbot(message)
    return response

def prompt_chatbot(message):
    prompt = f"""[INST] 
        You are a knowledgeable swimming coach assistant. Provide helpful advice on swimming techniques, training plans, and competition strategies.

        When discussing swimming strokes, be precise about body positioning and technique.
        For training questions, consider the user's experience level.
        Keep responses concise and practical.

        User question: {message} [/INST]
    """
    outputs = chat_pipeline(prompt, max_new_tokens=150, do_sample=True, temperature=0.7)
    response = result[0]["generated_text"]
    return {"response": response}


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
