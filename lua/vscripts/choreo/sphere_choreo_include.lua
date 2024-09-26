WHEATLEY = 0
GLADOS = 1

TURRET = 2
COMPUTER = 3

NextNagTime = -1
NextNagLine = -1

NextSpeakTime = -1
NextSpeakLine = -1

NagLine1 = -1
NagLine2 = -1

Dialog = {}

function SpeakLine(line)
    NextNagTime = -1
    NextSpeakTime = -1

    EntFire( "sphere_text_1", "SetText", "", 0 )	
	EntFire( "sphere_text_1", "Display", "", 0 )	
	EntFire( "sphere_text_2", "SetText", "", 0 )
	EntFire( "sphere_text_2", "Display", "", 0 )
	EntFire( "glados_text_1", "SetText", "", 0 )	
	EntFire( "glados_text_1", "Display", "", 0 )	
	EntFire( "glados_text_2", "SetText", "", 0 )
	EntFire( "glados_text_2", "Display", "", 0 )

    local dialogLine = Dialog[line]

    if dialogLine then
        if dialogLine.speaker then
            if dialogLine.speaker == GLADOS then
                if dialogLine.one then
                    EntFire( "glados_text_1", "SetText", "GLaDOS: " .. dialogLine.one, 0 )
                    EntFire( "glados_text_1", "Display", "", 0 )
                    
                    EntFire( "glados_text_2", "SetText", "", 0 )
                    EntFire( "glados_text_2", "Display", "", 0 )
                end
    
                if dialogLine.two then
                    EntFire( "glados_text_2", "SetText", "GLaDOS: " .. dialogLine.two, 0 )
                    EntFire( "glados_text_2", "Display", "", 0.75 )		
                end
            elseif dialog.speaker == WHEATLEY then
                if dialogLine.one then
                    EntFire( "sphere_text_1", "SetText", "Wheatley: " .. dialogLine.one, 0 )
                    EntFire( "sphere_text_1", "Display", "", 0 )
                    
                    EntFire( "sphere_text_2", "SetText", "", 0 )
                    EntFire( "sphere_text_2", "Display", "", 0 )
                end
    
                if dialogLine.two then
                    EntFire( "sphere_text_2", "SetText", "Wheatley: " + dialogLine.two, 0 )
                    EntFire( "sphere_text_2", "Display", "", 0.75 )		
                end
            elseif dialog.speaker == TURRET then
                if dialogLine.one then
                    EntFire( "sphere_text_1", "SetText", "Turret: " .. dialogLine.one, 0 )
                    EntFire( "sphere_text_1", "Display", "", 0 )
                    
                    EntFire( "sphere_text_2", "SetText", "", 0 )
                    EntFire( "sphere_text_2", "Display", "", 0 )
                end
    
                if dialogLine.two then
                    EntFire( "sphere_text_2", "SetText", "Turret: " + dialogLine.two, 0 )
                    EntFire( "sphere_text_2", "Display", "", 0.75 )		
                end
            elseif dialog.speaker == COMPUTER then
                if dialogLine.one then
                    EntFire( "sphere_text_1", "SetText", "Computer: " .. dialogLine.one, 0 )
                    EntFire( "sphere_text_1", "Display", "", 0 )
                    
                    EntFire( "sphere_text_2", "SetText", "", 0 )
                    EntFire( "sphere_text_2", "Display", "", 0 )
                end
    
                if dialogLine.two then
                    EntFire( "sphere_text_2", "SetText", "Computer: " + dialogLine.two, 0 )
                    EntFire( "sphere_text_2", "Display", "", 0.75 )		
                end
            end
        end
        
        if dialogLine.nextLine then
            if dialogLine.nextLineDelay then
                NextSpeakTime = CurTime() + dialogLine.nextLineDelay
            else
                NextSpeakTime = CurTime() + 5
            end

            NextSpeakLine = dialogLine.nextLine
        else
            NextSpeakTime = -1
            NextSpeakLine = -1
        end

        if dialogLine.nagDelay then
            if dialogLine.nextLine then
                print("Hey Dummy! How are you going to nag and speak another line? Well - I'm waiting?!?")
                print("Hey Dummy! How are you going to nag and speak another line? Well - I'm waiting?!?")
                print("Hey Dummy! How are you going to nag and speak another line? Well - I'm waiting?!?")
                print("Hey Dummy! How are you going to nag and speak another line? Well - I'm waiting?!?")
                print("Hey Dummy! How are you going to nag and speak another line? Well - I'm waiting?!?")

                NextSpeakTime = -1
                NextSpeakLine = -1
            end

            NextNagLine = line
            NextNagTime = CurTime() + dialogLine.nagDelay
        end

        if dialogLine.relay then
            EntFire( dialogLine.relay, "Trigger", "", dialogLine.relayDelay )
        end
    end
end

function Think()
    if NextSpeakTime > -1 and NextSpeakLine > -1 and CurTime() > NextSpeakTime then
        SpeakLine( NextSpeakLine ) -- this might set new next lines to speak.
    elseif NextNagTime > -1 and NextNagLine > -1 and CurTime() > NextNagTime then
        SpeakLine( NextNagLine )
    end
end

function NextLine()
    if NextSpeakLine > -1 then
        SpeakLine( NextSpeakLine )
    elseif NextNagLine > -1 then
        SpeakLine( NextNagLine )
    end
end