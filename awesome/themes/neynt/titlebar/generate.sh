convert close_focus.png -alpha on -channel A -evaluate divide 2 close_normal.png
for i in floating maximized ontop sticky; do
    convert ${i}_focus_active.png -channel A -evaluate set 0 ${i}_normal_inactive.png
    convert ${i}_focus_active.png -channel A -evaluate divide 2 ${i}_normal_active.png
    convert ${i}_focus_active.png -channel A -evaluate divide 2 ${i}_focus_inactive.png
done
