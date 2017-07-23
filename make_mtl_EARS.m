% This program converts the Mode Transition table text requirements

% Copyright Natasha Jeppu, natasha.jeppu@gmail.com
% http://www.mathworks.com/matlabcentral/profile/authors/5987424-natasha-jeppu

clear all 
clc 
offset=[0
0
0
0
0
0
6
6
8
8
8
];

trig={'AP'
'SPD'
'VS'
'ALT'
'ALTS'
'ALTCAP'
'ALTCPDN'
'APFAIL'
};

state={'DIS(Vertical)'
'PAH'
'SPD HOLD'
'VS'
'ALT HOLD'
'ALTS CAP'
'AP ON'
'AP OFF'
'ALTS OFF'
'ALTS ARM'
'ALTSEL CAP'
};

cond={'C1'
    'C2'
    'C3'
    'C4'
    'C5'
};


    % Vertical Mode
    V=[02	00	00	00	00	00	00	00
        01	03	04	05	00	06	00	01
        01	02	04	05	00	06	00	01
        01	03	02	05	00	06	00	01
        01	03	04	02	00	00	00	01
        01	00	00	05	00	00	05	01
        ];
    % AP Mode
    AP=[02	00	00	00	00	00	00	02
        01	00	00	00	00	00	00	00
        ];
    %Altsel Mode
    AS=[00	00	00	00	02	00	00	00
        01	00	00	01	01	03	00	01
        01	00	00	01	00	00	01	01
        ];
    
    %Condition Matrix - vertical
    CV=[01	00	00	00	00	00	00	00
        02	03	04	05	00	00	00	02
        02	00	04	05	00	00	00	02
        02	03	00	05	00	00	00	02
        02	03	04	00	00	00	00	02
        02	00	00	05	00	00	00	02
        ];
    %Condition Matrix - AP
    CAP=[00	00	00	00	00	00	00	00
        01	00	00	00	00	00	00	00
        ];
    %Condition Matrix - AltSel
    CAS=[00	00	00	00	00	00	00	00
        02	00	00	05	00	00	00	02
        02	00	00	05	00	00	00	02
        ];

T = [V;AP;AS];
C = [CV;CAP;CAS];

[ns,c]=size(T);
nt=length(trig);
ic = 0;
for i = 1:ns  % no of states
    for j = 1:nt   % no of triggers
        if T(i,j) ~= 0
            if T(i,j) < 100   % only one 
                if C(i,j) == 0  % there is no condition
                    condt = '';
                else
                    condt = ['AND condition ' cond{C(i,j)} ' is TRUE']; % only one condition
                end
                ic = ic+1;
                if(strcmp(state{i},state{T(i,j)+offset(i)}))
                    disp([num2str(ic) ') While in State ' state{i} ', When Trigger ' trig{j} ' occurs ' condt ', the Autopilot Mode shall remain in State ' state{T(i,j)+offset(i)} '.' ]);
                else
                    disp([num2str(ic) ') While in State ' state{i} ' , When Trigger ' trig{j} ' occurs ' condt ', the Autopilot Mode shall transit to State ' state{T(i,j)+offset(i)} '.']);
                end
                
            elseif T(i,j) >= 100  && T(i,j) <= 9999% there are two transitions
                a=T(i,j)-fix(T(i,j)/100)*100;
                if C(i,j) == 0  % there is no condition
                    condt = ' [No Condition required] '; 
                else
                    b=C(i,j)-fix(C(i,j)/100)*100;
                    condt = cond{b}; % only one condition
                end 
                ic = ic+1;
                if(strcmp(state{i},state{a+offset(i)}))
                    disp([num2str(ic) ') If in State ' state{i} ' AND Trigger ' trig{j} ' occurs THEN remain in ' state{a+offset(i)} ' if condition ' condt ' Is TRUE']);
                else
                    disp([num2str(ic) ') If in State ' state{i} ' AND Trigger ' trig{j} ' occurs THEN transit to ' state{a+offset(i)} ' if condition ' condt ' Is TRUE']);
                end
                
                a=fix(T(i,j)/100);  % get the second transition
                if C(i,j) == 0  % there is no condition
                    condt = ' [No Condition required] ';
                else
                    b=fix(C(i,j)/100);
                    condt = cond{b}; % only one condition
                end 
                ic = ic+1;
                if(strcmp(state{i},state{a+offset(i)}))
                    disp([num2str(ic) ') If in State ' state{i} ' AND Trigger ' trig{j} ' occurs THEN remain in ' state{a+offset(i)} ' if condition ' condt ' Is TRUE']);
                else
                    disp([num2str(ic) ') If in State ' state{i} ' AND Trigger ' trig{j} ' occurs THEN transit to ' state{a+offset(i)} ' if condition ' condt ' Is TRUE']);
                end  
                
                
                elseif  T(i,j) > 9999% there are three transitions
                    
                a=T(i,j)-fix(T(i,j)/100)*100;
                if C(i,j) == 0  % there is no condition
                    condt = ' [No Condition required] ';
                else
                    b=C(i,j)-fix(C(i,j)/100)*100;
                    condt = cond{b}; % only one condition
                end 
                ic = ic+1;
                if(strcmp(state{i},state{a+offset(i)}))
                    disp([num2str(ic) ') If in State ' state{i} ' AND Trigger ' trig{j} ' occurs THEN remain in ' state{a+offset(i)} ' if condition ' condt ' Is TRUE']);
                else
                    disp([num2str(ic) ') If in State ' state{i} ' AND Trigger ' trig{j} ' occurs THEN transit to ' state{a+offset(i)} ' if condition ' condt ' Is TRUE']);
                end
                    
                a=T(i,j)-fix(T(i,j)/10000)*10000;a=fix(a/100);  % gets the second
                if C(i,j) == 0  % there is no condition
                    condt = ' [No Condition required] ';
                else
                    b=C(i,j)-fix(C(i,j)/10000)*10000;b=fix(b/100);
                    condt = cond{b}; % only one condition
                end 
                ic = ic+1;
                if(strcmp(state{i},state{a+offset(i)}))
                    disp([num2str(ic) ') If in State ' state{i} ' AND Trigger ' trig{j} ' occurs THEN remain in ' state{a+offset(i)} ' if condition ' condt ' Is TRUE']);
                else
                    disp([num2str(ic) ') If in State ' state{i} ' AND Trigger ' trig{j} ' occurs THEN transit to ' state{a+offset(i)} ' if condition ' condt ' Is TRUE']);
                end
                
                a=fix(T(i,j)/10000);  % get the second transition
                if C(i,j) == 0  % there is no condition
                    condt = ' [No Condition required] ';
                else
                    b=fix(C(i,j)/10000);
                    condt = cond{b}; % only one condition
                end 
                ic = ic+1;
                if(strcmp(state{i},state{a+offset(i)}))
                    disp([num2str(ic) ') If in State ' state{i} ' AND Trigger ' trig{j} ' occurs THEN remain in ' state{a+offset(i)} ' if condition ' condt ' Is TRUE']);
                else
                    disp([num2str(ic) ') If in State ' state{i} ' AND Trigger ' trig{j} ' occurs THEN transit to ' state{a+offset(i)} ' if condition ' condt ' Is TRUE']);
                end
                
            end
        end
    end
end
