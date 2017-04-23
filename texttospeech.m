%%
%Text to Speech
function texttospeech(display)
NET.addAssembly('System.Speech');
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;
Speak(obj,char(display));
end 
