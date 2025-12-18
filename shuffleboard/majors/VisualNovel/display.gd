extends RichTextLabel

@export var text_font_size: int = 50
@export var text_font_color: Color = Color(1.0, 1.0, 1.0, 1.0)

func display_self(new_text: String) -> void:
	print("hi!")
	clear()
	
	push_font_size(self.text_font_size)
	push_color(self.text_font_color)
	
	add_text(new_text)
