extends Control
class_name Textbox

@export var speaker_font_size: int = 26
@export var text_font_size: int = 20
@export var text_font_color: Color = Color(0.0, 0.0, 0.0, 1.0)

var speaker: RichTextLabel
var text_box: RichTextLabel

func _ready() -> void:
	self.speaker = $Speaker
	self.text_box = $Text

func set_speaker(speaker_data: Dictionary) -> void:
	self.speaker.push_font_size(self.speaker_font_size)
	self.speaker.push_color(Color(
		speaker_data["color"][0],
		speaker_data["color"][1],
		speaker_data["color"][2],
		speaker_data["color"][3]
	))
	
	self.speaker.add_text(speaker_data["speaker"])

func display_text(text_data: Dictionary) -> void:
	# text_data = { speaker: { speaker, color }, text }
	clear_text()
	
	set_speaker(text_data["speaker_data"])
	
	self.text_box.push_font_size(self.text_font_size)
	self.text_box.push_color(self.text_font_color)
	self.text_box.add_text(text_data["text"])

func clear_text() -> void:
	self.speaker.clear()
	self.text_box.clear()
