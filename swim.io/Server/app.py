from flask import Flask, request, jsonify
from flask_cors import CORS
from transformers import AutoModelForCausalLM, AutoTokenizer
import os
from dotenv import load_dotenv
from huggingface_hub import login

load_dotenv()
MODEL_NAME = "meta-llama/Llama-2-7b-chat-hf"
API_TOKEN = os.getenv("HUGGINGFACE_API_KEY")
login(token=API_TOKEN)
app = Flask(__name__)
CORS(app)

tokenizer = AutoTokenizer.from_pretrained("meta-llama/Llama-2-7b-chat-hf")
model = AutoModelForCausalLM.from_pretrained(
    MODEL_NAME,
    load_in_4bit=True,
)

@app.route("/chat", methods=["POST"])
def chat():
    data = request.json
    message = request.get('message', '')
    if not user_message:
        return jsonify({"error": "Message is required"}), 400
    response = prompt_chatbot(message)
    return response

def prompt_chatbot(message):
    prompt = f"""
        <s>[INST]
        You are a knowledgeable swimming coach assistant. Provide helpful advice on swimming techniques, training plans, and competition strategies.
    
        When discussing swimming strokes, be precise about body positioning and technique.
        For training questions, consider the user's experience level.
        Keep responses concise and practical.
        
        User question: {message} [/INST]
        </s>
    """
    inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
    outputs = model.generate(
        inputs["input_ids"],
        max_new_tokens=200,
        temperature=0.7,
        top_p=0.95,
        repetition_penalty=1.1,
        do_sample=True
    )
    response = tokenizer.decode(outputs[0], skip_special_tokens=True)
    response = response.replace(prompt, "").strip()
    return response


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
