
function fig_drone2021
%面積指定をした部分の飛行経路生成関数の追加→squrepath
fig = figure('Visible','on','Position',...
    [80,100,1400,700],'Name','Drone Path Planning GUI');
movegui(fig,'center')

%検証用　デフォルト設定可能
start_point = [-40 -2.5 0.2];
subgoal_point = [-63 0.5 1.8];
goal_point = [-25 -10 0.2];
p2= [-63 0.5 1.8];
p3= [-63 0.5 1.8];
p4=[-25 -10 0.2];
% global start_point,p2,p3,p4


%button UI部分
hstart = uicontrol('Style','pushbutton','String','START',...
    'Position',[940,450,120,25],'Callback',@Startbutton_Callback);
hstop = uicontrol('Style','pushbutton','String','STOP',....
    'Position',[1000,420,120,25],'Callback',@Stopbutton_Callback);
houtput = uicontrol('Style','pushbutton','String','.txt file Output',...
    'Position',[1050,50,120,25],'Callback',@Outputbutton_Callback);
hbutton1  = uicontrol('Style','pushbutton','String','SET:Start_Point',...
    'Position',[1050,620,120,25],'Callback',...
    @a);
hbutton2  = uicontrol('Style','pushbutton','String','SET:Goal_Point',...
    'Position',[1050,580,120,25],'Callback',...
    @c);
hbutton3  = uicontrol('Style','pushbutton','String','SET:SubGoal_Point',...
    'Position',[1050,500,120,25],'Callback',...
    @b);

buttun_squre=uicontrol('Style','pushbutton','String','SET:Squre_Point',...
    'Position',[1000,350,120,25],'Callback',...
    @d);

%text
htext4  = uicontrol('Style','text','String','Trajectory_GPSdata',...
    'Position',[1050,75,120,15]);
%pop-up-menu
hpopup = uicontrol('Style','popupmenu','String',...
    {'Mode_1','Mode_2','Mode_3','Mode_4','squre'},'Position',...
    [1050,535,100,25],'Callback',@popup_menu_Callback);
    function a(~,~)
        start_point=Buttun.SetStartPointbutton_Callback;
    end
    function b(~,~)
        subgoal_point=Buttun.SetStartPointbutton_Callback;
    end
    function c(~,~)
        goal_point=Buttun.SetStartPointbutton_Callback;
    end
    function d(~,~)
        squre_points=Buttun.set_squre_buttun(fig);
        start_point=squre_points(4,:);    
        p2=squre_points(3,:);
        p3=squre_points(2,:);
        p4=squre_points(1,:);
    end
% Initialize the UI.
% Change units to normalized so components resize automatically.
fig.Units = 'normalized';
ax.Units = 'normalized';
houtput.Units = 'normalized';
hstart.Units = 'normalized';
hstop.Units = 'normalized';
hbutton1.Units = 'normalized';
hbutton2.Units = 'normalized';
hbutton3.Units = 'normalized';
buttun_squre='normalized';
htext4.Units = 'normalized';
hpopup.Units = 'normalized';
h.Units = 'normalized';
%image-area
%imdata = imread('kc3.png');
%imdata2 = imresize(imdata,1/2.5);
%h = uicontrol('style','pushbutton','position',[940 150 400 250],...
%           'BackgroundColor','white');
%set(h,'cdata',imdata2)
%plot-area
ax = axes('Units','pixels','Position',[50,50,800,600]);
hold(ax,'on')
view(45,30);
xlim([-70 10]);ylim([-45 10]);zlim([0 10]);
xlabel('x')
ylabel('y')
zlabel('z')

%align([houtput,hstart,hstop,hbutton1,hbutton2,hbutton3,...
%    htext4,hpopup,h],'Center','None');
align([houtput,hstart,hstop,hbutton1,hbutton2,hbutton3,...
    htext4,hpopup],'Center','None');

%{
scatter3(start_point(1),start_point(2),start_point(3),50,[0,0.6,1],...
    'filled');%青点 Mode_4検証用
scatter3(subgoal_point(1),subgoal_point(2),subgoal_point(3),50,[1,0,1],...
    'filled');%紫点 Mode_4検証用
scatter3(goal_point(1),goal_point(2),goal_point(3),50,[1,0,0],...
    'filled');%赤点 Mode_4検証用
    %}
    
    %.plyデータ（ソリッドモデルのインポート＆行列形式の点群データへの変換）
    %一回目の地形データ；一番広いモデル
    ptCloud = pcread('model_1.ply');
    x = ptCloud.Location(:,1)-1.5565;
    y = ptCloud.Location(:,3)-51.7600;
    z = ptCloud.Location(:,2)-20.1052;
    th1=-89.9;
    x2=x-25.7662;
    y2=y+11.7275;
    x3=x2*cos(th1)-y2*sin(th1);
    y3=x2*sin(th1)+y2*cos(th1);
    %ここから補正(主に地面の傾斜；それぞれx軸方向の傾斜の補正，y軸方向の傾斜の補正)
    z1=(z-(x3/40))*0.9-2.0;
    z2=z1-(y3/57)+0.3;
    if z2<0
        z2=0;
    end
    
    %二回目の地形データ；南東側の樹木
    ptC = pcread('model_2.ply');
    xx = ptC.Location(:,1)/10000;
    yy = ptC.Location(:,2)/10000;
    zz = ptC.Location(:,3)/10000;
    xx1 = (xx+3.78011)*1000;
    yy1 = (yy+1.09741)*1000;
    zz1 = ((zz-5.02941)*10000+0.6)*0.7;
    th2=-89.9;
    xx2=xx1*cos(th2)-yy1*sin(th2);
    yy2=xx1*sin(th2)+yy1*cos(th2);
    xx3 = xx2*10-5;
    yy3 = yy2*10-21.42;
    
    %三回目の地形データ；西側のアルミ枠に囲まれた小さな木
    pC = pcread('model_3.ply');
    xxx = pC.Location(:,1)+8.55391;
    yyy = pC.Location(:,2)+4.07232;
    zzz = pC.Location(:,3)+(0.6/17.2)*yyy+0.4;
    th3=-0.65;
    xxx1=(xxx*cos(th3)-yyy*sin(th3))-63.3552;
    yyy1=(xxx*sin(th3)+yyy*cos(th3))-2.72367;
    
    %全てのデータの合成
    %単位はｍ
    X = [x3;xx3;xxx1];
    Y = [-y3;yy3;yyy1];
    Z = [z2;zz1;zzz];
    scatter3(ax,X,Y,Z,1,[0 1 0],'filled');
    grid on
    
    %二次元の動き
    %入力された目標値までの差
    p = goal_point(1)-start_point(1);
    q = goal_point(2)-start_point(2);
    u = subgoal_point(1)-start_point(1);
    v = subgoal_point(2)-start_point(2);
    n = goal_point(1)-subgoal_point(1);
    o = goal_point(2)-subgoal_point(2);
    %一回の動作で移動する大きさ
    % 200→50　減らせば一回の動作が大きくなり経路が荒くなる
    % 200→400　増やせば動作回数(for文)が大きくなる
    px = abs(p / 200);
    qy = abs(q / 200);
    ux = abs(u / 200);
    vy = abs(v / 200);
    nx = abs(n / 200);
    oy = abs(o / 200);
    drone_pos = start_point;
    traject_list = [drone_pos];
    line1 = plot3(traject_list(1),traject_list(2),traject_list(3));
    
    %distance
    %ここで判定の距離を設定
    object_r = 0.6;%障害物の周りに空間を設置
    drone_r = 0.5;%ドローンの大きさを反映
    r = object_r + drone_r;
    
    %simulation_time
    t_min = 0;
    dt = 0.1;
    t_max = 200;
    current_data = 1;
    
    %pop_up_menu
    function popup_menu_Callback(source,~)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val}
            case 'Mode_1'
                current_data = 1;
            case 'Mode_2'
                current_data = 2;
            case 'Mode_3'
                current_data = 3;
            case 'Mode_4'
                current_data = 4;
            case 'squre'
                current_data = 5;
        end
    end%%function-end

%Stop-button
    function Stopbutton_Callback(~,~)
        pause(10);
    end%%function-end

%Start-button
    function Startbutton_Callback(~,~)
        if current_data == 1
            drone_pos = start_point;
            drone1 = scatter3(drone_pos(1),drone_pos(2),drone_pos(3),50,...
                [0,0.5,0.5],'filled');
            traject_list = [drone_pos];
            line1 = plot3(traject_list(1),traject_list(2),traject_list(3));
            line1.LineWidth = 1;
            for t = t_min:dt:t_max
                a = X - drone_pos(1);
                b = Y - drone_pos(2);
                c = Z - drone_pos(3);
                d = a.^2 + b.^2 + c.^2;
                
                if abs(goal_point(1)-drone_pos(1))<=0.2 ...
                        && abs(goal_point(2)-drone_pos(2))<=0.2
                    if drone_pos(3)>goal_point(3)
                        drone_pos(3) = drone_pos(3)-0.03;
                    else
                        drone_pos(3) = drone_pos(3)+0;
                        break
                    end
                else
                    if sqrt(min(d))>1.5*r && drone_pos(3)>3
                        drone_pos(3) = drone_pos(3)-0.1;
                    elseif sqrt(min(d))>r
                        if abs(goal_point(1)-drone_pos(1))>0.2 ...
                                && abs(goal_point(2)-drone_pos(2))>0.2
                            if drone_pos(1) > goal_point(1) ...
                                    && drone_pos(2) > goal_point(2)
                                drone_pos(1) = drone_pos(1)-px;
                                drone_pos(2) = drone_pos(2)-qy;
                            elseif drone_pos(1) < goal_point(1) ...
                                    && drone_pos(2) > goal_point(2)
                                drone_pos(1) = drone_pos(1)+px;
                                drone_pos(2) = drone_pos(2)-qy;
                            elseif drone_pos(2) < goal_point(2) ...
                                    && drone_pos(1) > goal_point(1)
                                drone_pos(2) = drone_pos(2)+qy;
                                drone_pos(1) = drone_pos(1)-px;
                            elseif drone_pos(2) < goal_point(2) ...
                                    && drone_pos(1) < goal_point(1)
                                drone_pos(2) = drone_pos(2)+qy;
                                drone_pos(1) = drone_pos(1)+px;
                            end
                        elseif abs(goal_point(2)-drone_pos(2))<=0.2
                            if drone_pos(1) > goal_point(1)
                                drone_pos(1) = drone_pos(1)-0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            elseif drone_pos(1) < goal_point(1)
                                drone_pos(1) = drone_pos(1)+0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            else
                                drone_pos(1) = drone_pos(1)+0;
                            end
                        elseif abs(goal_point(1)-drone_pos(1))<=0.2
                            if drone_pos(2) > goal_point(2)
                                drone_pos(2) = drone_pos(2)-0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            elseif drone_pos(2) < goal_point(2)
                                drone_pos(2) = drone_pos(2)+0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            else
                                drone_pos(2) = drone_pos(2)+0;
                            end
                        end
                    else
                        drone_pos(3) = drone_pos(3)+0.03;
                    end
                end
                drone1.XData = drone_pos(1);
                drone1.YData = drone_pos(2);
                drone1.ZData = drone_pos(3);
                traject_list =  [traject_list;drone_pos];
                line1.XData = traject_list(:,1);
                line1.YData = traject_list(:,2);
                line1.ZData = traject_list(:,3);
                pause(0.01);
            end%%for-end
        elseif current_data == 2
            drone_pos = start_point;
            drone1 = scatter3(drone_pos(1),drone_pos(2),drone_pos(3),50,...
                [0,0.5,0.5],'filled');
            traject_list = [drone_pos];
            line2 = plot3(traject_list(1),traject_list(2),traject_list(3));
            line2.LineWidth = 1;
            for t = t_min:dt:t_max
                a = X - drone_pos(1);
                b = Y - drone_pos(2);
                c = Z - drone_pos(3);
                d = a.^2 + b.^2 + c.^2;
                
                if abs(goal_point(2)-drone_pos(2))<=0.2 ...
                        && abs(goal_point(1)-drone_pos(1))<=0.2
                    if drone_pos(3)>goal_point(3)
                        drone_pos(3) = drone_pos(3)-0.03;
                    else
                        drone_pos(3) = drone_pos(3)+0;
                        break
                    end
                else
                    if sqrt(min(d))>1.5*r && drone_pos(3)>3
                        drone_pos(3) = drone_pos(3)-0.1;
                    elseif sqrt(min(d))>r
                        if abs(goal_point(2)-drone_pos(2))<=0.2
                            if drone_pos(1) > goal_point(1)
                                drone_pos(1) = drone_pos(1)-0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            elseif drone_pos(1) < goal_point(1)
                                drone_pos(1) = drone_pos(1)+0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            else
                                drone_pos(1) = drone_pos(1)+0;
                            end
                        elseif abs(goal_point(1)-drone_pos(1))<=0.2
                            if drone_pos(2) > goal_point(2)
                                drone_pos(2) = drone_pos(2)-0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            elseif drone_pos(2) < goal_point(2)
                                drone_pos(2) = drone_pos(2)+0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            else
                                drone_pos(2) = drone_pos(2)+0;
                            end
                        else
                            if drone_pos(2) > goal_point(2)
                                drone_pos(2) = drone_pos(2)-0.1;
                                drone_pos(2) = drone_pos(2)-0.1;
                            elseif drone_pos(2) < goal_point(2)
                                drone_pos(2) = drone_pos(2)+0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            elseif drone_pos(1) > goal_point(1)
                                drone_pos(1) = drone_pos(1)-0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            elseif drone_pos(1) < goal_point(1)
                                drone_pos(1) = drone_pos(1)+0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            end
                        end
                    else
                        drone_pos(3) = drone_pos(3)+0.03;
                    end
                end
                drone1.XData = drone_pos(1);
                drone1.YData = drone_pos(2);
                drone1.ZData = drone_pos(3);
                traject_list =  [traject_list;drone_pos];
                line2.XData = traject_list(:,1);
                line2.YData = traject_list(:,2);
                line2.ZData = traject_list(:,3);
                pause(0.01);
            end%%for-end
        elseif current_data == 3
            drone_pos = start_point;
            drone1 = scatter3(drone_pos(1),drone_pos(2),drone_pos(3),50,...
                [0,0.5,0.5],'filled');
            traject_list = [drone_pos];
            line3 = plot3(traject_list(1),traject_list(2),traject_list(3));
            line3.LineWidth = 1;
            for t = t_min:dt:t_max
                a = X - drone_pos(1);
                b = Y - drone_pos(2);
                c = Z - drone_pos(3);
                d = a.^2 + b.^2 + c.^2;
                
                if abs(goal_point(1)-drone_pos(1))<=0.2 ...
                        && abs(goal_point(2)-drone_pos(2))<=0.2
                    if drone_pos(3)>goal_point(3)
                        drone_pos(3) = drone_pos(3)-0.03;
                    else
                        drone_pos(3) = drone_pos(3)+0;
                        break
                    end
                else
                    if sqrt(min(d))>1.5*r && drone_pos(3)>3
                        drone_pos(3) = drone_pos(3)-0.1;
                    elseif sqrt(min(d))>r
                        if abs(goal_point(1)-drone_pos(1))<=0.2
                            if drone_pos(2) > goal_point(2)
                                drone_pos(2) = drone_pos(2)-0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            elseif drone_pos(2) < goal_point(2)
                                drone_pos(2) = drone_pos(2)+0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            else
                                drone_pos(2) = drone_pos(2)+0;
                            end
                        elseif abs(goal_point(2)-drone_pos(2))<=0.2
                            if drone_pos(1) > goal_point(1)
                                drone_pos(1) = drone_pos(1)-0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            elseif drone_pos(1) < goal_point(1)
                                drone_pos(1) = drone_pos(1)+0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            else
                                drone_pos(1) = drone_pos(1)+0;
                            end
                        else
                            if drone_pos(1) > goal_point(1)
                                drone_pos(1) = drone_pos(1)-0.1;
                                drone_pos(1) = drone_pos(1)-0.1;
                            elseif drone_pos(1) < goal_point(1)
                                drone_pos(1) = drone_pos(1)+0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            elseif drone_pos(2) > goal_point(2)
                                drone_pos(2) = drone_pos(2)-0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            elseif drone_pos(2) < goal_point(2)
                                drone_pos(2) = drone_pos(2)+0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            end
                        end
                    else
                        drone_pos(3) = drone_pos(3)+0.03;
                    end
                end
                drone1.XData = drone_pos(1);
                drone1.YData = drone_pos(2);
                drone1.ZData = drone_pos(3);
                traject_list =  [traject_list;drone_pos];
                line3.XData = traject_list(:,1);
                line3.YData = traject_list(:,2);
                line3.ZData = traject_list(:,3);
                pause(0.01);
            end%%for-end
        elseif current_data == 4
            drone_pos = start_point;
            drone1 = scatter3(drone_pos(1),drone_pos(2),drone_pos(3),50,...
                [0,0.5,0.5],'filled');
            traject_list = [drone_pos];
            line4 = plot3(traject_list(1),traject_list(2),traject_list(3));
            line4.LineWidth = 1;
            for t = t_min:dt:t_max
                a = X - drone_pos(1);
                b = Y - drone_pos(2);
                c = Z - drone_pos(3);
                d = a.^2 + b.^2 + c.^2;
                
                if abs(subgoal_point(1)-drone_pos(1))<=0.2 ...
                        && abs(subgoal_point(2)-drone_pos(2))<=0.2
                    if drone_pos(3)<=subgoal_point(3)+0.1 ...
                            && drone_pos(3)>=subgoal_point(3)-0.1
                        break
                    elseif drone_pos(3)<subgoal_point(3)-0.1
                        drone_pos(3) = drone_pos(3)+0.03;
                    elseif drone_pos(3)>subgoal_point(3)+0.1
                        drone_pos(3) = drone_pos(3)-0.03;
                    end
                else
                    if sqrt(min(d))>2*r && drone_pos(3)>3
                        drone_pos(3) = drone_pos(3)-0.1;
                    elseif sqrt(min(d))>r
                        if abs(subgoal_point(1)-drone_pos(1))>0.2 ...
                                && abs(subgoal_point(2)-drone_pos(2))>0.2
                            if drone_pos(1) > subgoal_point(1) ...
                                    && drone_pos(2) > subgoal_point(2)
                                drone_pos(1) = drone_pos(1)-ux;
                                drone_pos(2) = drone_pos(2)-vy;
                            elseif drone_pos(1) < subgoal_point(1) ...
                                    && drone_pos(2) > subgoal_point(2)
                                drone_pos(1) = drone_pos(1)+ux;
                                drone_pos(2) = drone_pos(2)-vy;
                            elseif drone_pos(2) < subgoal_point(2) ...
                                    && drone_pos(1) > subgoal_point(1)
                                drone_pos(2) = drone_pos(2)+ux;
                                drone_pos(1) = drone_pos(1)-vy;
                            elseif drone_pos(2) < subgoal_point(2) ...
                                    && drone_pos(1) < subgoal_point(1)
                                drone_pos(2) = drone_pos(2)+ux;
                                drone_pos(1) = drone_pos(1)+vy;
                            end
                        elseif abs(subgoal_point(2)-drone_pos(2))<=0.2
                            if drone_pos(1) > subgoal_point(1)
                                drone_pos(1) = drone_pos(1)-0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            elseif drone_pos(1) < subgoal_point(1)
                                drone_pos(1) = drone_pos(1)+0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            else
                                drone_pos(1) = drone_pos(1)+0;
                            end
                        elseif abs(subgoal_point(1)-drone_pos(1))<=0.2
                            if drone_pos(2) > subgoal_point(2)
                                drone_pos(2) = drone_pos(2)-0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            elseif drone_pos(2) < subgoal_point(2)
                                drone_pos(2) = drone_pos(2)+0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            else
                                drone_pos(2) = drone_pos(2)+0;
                            end
                        end
                    else
                        drone_pos(3) = drone_pos(3)+0.03;
                    end
                end
                drone1.XData = drone_pos(1);
                drone1.YData = drone_pos(2);
                drone1.ZData = drone_pos(3);
                traject_list =  [traject_list;drone_pos];
                line4.XData = traject_list(:,1);
                line4.YData = traject_list(:,2);
                line4.ZData = traject_list(:,3);
                pause(0.01);
            end%%for-end
            for t = t_min:dt:t_max
                a = X - drone_pos(1);
                b = Y - drone_pos(2);
                c = Z - drone_pos(3);
                d = a.^2 + b.^2 + c.^2;
                
                if abs(goal_point(1)-drone_pos(1))<=0.2 ...
                        && abs(goal_point(2)-drone_pos(2))<=0.2
                    if drone_pos(3)>goal_point(3)
                        drone_pos(3) = drone_pos(3)-0.03;
                    else
                        drone_pos(3) = drone_pos(3)+0;
                        break
                    end
                else
                    if sqrt(min(d))>2*r && drone_pos(3)>3
                        drone_pos(3) = drone_pos(3)-0.1;
                    elseif sqrt(min(d))>r
                        if abs(goal_point(1)-drone_pos(1))>0.2 ...
                                && abs(goal_point(2)-drone_pos(2))>0.2
                            if drone_pos(1) > goal_point(1) ...
                                    && drone_pos(2) > goal_point(2)
                                drone_pos(1) = drone_pos(1)-nx;
                                drone_pos(2) = drone_pos(2)-oy;
                            elseif drone_pos(1) < goal_point(1) ...
                                    && drone_pos(2) > goal_point(2)
                                drone_pos(1) = drone_pos(1)+nx;
                                drone_pos(2) = drone_pos(2)-oy;
                            elseif drone_pos(2) < goal_point(2) ...
                                    && drone_pos(1) > goal_point(1)
                                drone_pos(2) = drone_pos(2)+oy;
                                drone_pos(1) = drone_pos(1)-nx;
                            elseif drone_pos(2) < goal_point(2) ...
                                    && drone_pos(1) < goal_point(1)
                                drone_pos(2) = drone_pos(2)+oy;
                                drone_pos(1) = drone_pos(1)+nx;
                            end
                        elseif abs(goal_point(2)-drone_pos(2))<=0.2
                            if drone_pos(1) > goal_point(1)
                                drone_pos(1) = drone_pos(1)-0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            elseif drone_pos(1) < goal_point(1)
                                drone_pos(1) = drone_pos(1)+0.1;
                                drone_pos(2) = drone_pos(2)+0;
                            else
                                drone_pos(1) = drone_pos(1)+0;
                            end
                        elseif abs(goal_point(1)-drone_pos(1))<=0.2
                            if drone_pos(2) > goal_point(2)
                                drone_pos(2) = drone_pos(2)-0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            elseif drone_pos(2) < goal_point(2)
                                drone_pos(2) = drone_pos(2)+0.1;
                                drone_pos(1) = drone_pos(1)+0;
                            else
                                drone_pos(2) = drone_pos(2)+0;
                            end
                        end
                    else
                        drone_pos(3) = drone_pos(3)+0.03;
                    end
                end
                drone1.XData = drone_pos(1);
                drone1.YData = drone_pos(2);
                drone1.ZData = drone_pos(3);
                traject_list =  [traject_list;drone_pos];
                line4.XData = traject_list(:,1);
                line4.YData = traject_list(:,2);
                line4.ZData = traject_list(:,3);
                pause(0.01);
                
            end%%for-end
            
        elseif current_data == 5        
            drone_pos=start_point;
            goal_point=p2;
                  
            drone1 = scatter3(drone_pos(1),drone_pos(2),drone_pos(3),50,...
                [0,0.5,0.5],'filled');
            traject_list = [drone_pos];
            line1 = plot3(traject_list(1),traject_list(2),traject_list(3));
            line1.LineWidth = 1;
            %ゴールに達しているのか判定(2次元)
            drone_goal_distance=1.0;
            %ベクトルの設定
            P=(goal_point-drone_pos)./200;
            p23=abs(p3-p2)./3;
            p14=abs(p4-start_point)./3;
            
            
            drone_pos(3)=drone_pos(3)+1.0;
            while  drone_goal_distance>=0.02
                %             d=[X;Y;Z]-drone_pos;
                a = X - drone_pos(1);
                b = Y - drone_pos(2);
                c = Z - drone_pos(3);
                %物体との距離
                d =sqrt(min(a.^2 + b.^2 + c.^2));
                
                %物体が周りにない
                if d>r
                    drone_pos(1,1:2)=drone_pos(1,1:2)+P(1,1:2);
                    %物体をよける(上に行くプログラム
                else
                    drone_pos(3)=drone_pos(3)+0.03;
                end
                drone1.XData = drone_pos(1);
                drone1.YData = drone_pos(2);
                drone1.ZData = drone_pos(3);
                traject_list =  [traject_list;drone_pos];
                line1.XData = traject_list(:,1);
                line1.YData = traject_list(:,2);
                line1.ZData = traject_list(:,3);
                pause(0.01);
                drone_goal_distance=abs(drone_pos(1,1:2)-goal_point(1,1:2));
            end%%while-end
           
            goal=p2-p23;
            start=start_point-p14;
            start(3)=drone_pos(3);
            goal(3)=drone_pos(3);
            drone_pos=start_end(goal,start);
            
%             goal=p2-p23*2;
%             start=start_point-p14*2;
%             start(3)=drone_pos(3);
%             goal(3)=drone_pos(3);
%             drone_pos=start;
%             drone1 = scatter3(drone_pos(1),drone_pos(2),drone_pos(3),50,...
%                 [0,0.5,0.5],'filled');
%             drone_pos=start_end(start,goal);
            
            
            
            
            
            
%             for i=1:3
%                 p23=abs(p3-p2)./3;
%                 p14=abs(p4-start_point)./3;
%                 goal=p2-p23*i;
%                 start=start_point-p14*i;
%                 start(3)=drone_pos(3);
%                 goal(3)=drone_pos(3);
%                 if i%2==1
%                    drone_pos=start_end(goal,start);
%                 else
%                     drone_pos=start_end(start,goal);
%                 end
%             end
            drone_pos(3)=0.2;
            drone1.XData = drone_pos(1);
            drone1.YData = drone_pos(2);
            drone1.ZData = drone_pos(3);
            traject_list =  [traject_list;drone_pos];
            line1.XData = traject_list(:,1);
            line1.YData = traject_list(:,2);
            line1.ZData = traject_list(:,3);
            pause(0.01);
        end%%if-end
    end%%function-end

    function drone_pos=start_end(start,goal)
            drone_pos=start;
            drone1 = scatter3(drone_pos(1),drone_pos(2),drone_pos(3),50,...
                [0,0.5,0.5],'filled');
            %ゴールに達しているのか判定(2次元)
            drone_goal_distance=1.0;
            P=(goal-start)./200;
        while  drone_goal_distance>=0.02
                a = X - drone_pos(1);
                b = Y - drone_pos(2);
                c = Z - drone_pos(3);
                %物体との距離
                d =sqrt(min(a.^2 + b.^2 + c.^2));
                
                %物体が周りにない
                if d>r
                    drone_pos=drone_pos+P;
                    %物体をよける(上に行くプログラム
                else
                    drone_pos(3)=drone_pos(3)+0.03;
                end
                drone1.XData = drone_pos(1);
                drone1.YData = drone_pos(2);
                drone1.ZData = drone_pos(3);
                traject_list =  [traject_list;drone_pos];
                line1.XData = traject_list(:,1);
                line1.YData = traject_list(:,2);
                line1.ZData = traject_list(:,3);
                pause(0.01);
                drone_goal_distance=abs(drone_pos(1,1:2)-goal(1,1:2));
            end%%while-end
    end

%Output-button
    function Outputbutton_Callback(~,~)
        %traject_gps(:,1)=(0.000159/15.4979)*traject_list(:,1)+139.523553;
        %基準　N:139.523553
        %traject_gps(:,2)=(0.000239/26.3204)*traject_list(:,2)+35.709898;
        %基準　E:35.709898
        traject_gps(:,1)=(0.00069/63.4082)*traject_list(:,1)+139.523553;
        %基準　N:139.523553
        traject_gps(:,2)=(0.000376/36.6688)*traject_list(:,2)+35.709900;
        %基準　E:35.709900
        
        traject_gps(:,3)=traject_list(:,3);
        traject_navi = round(traject_list,7);
        writematrix(traject_navi);
        traject_gps = round(traject_gps,7);
        writematrix(traject_gps);
    end%%function-end
end



