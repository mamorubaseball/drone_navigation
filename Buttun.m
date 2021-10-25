classdef Buttun
    %UNTITLED3 このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
    end
    
    methods(Static)
        %Set-button_squre
        function squre_points=set_squre_buttun(fig)
        dcm_obj = datacursormode(fig)
        set(dcm_obj,'DisplayStyle','datatip',...
            'SnapToDataVertex','off','Enable','on')
        c_info = getCursorInfo(dcm_obj)
        %forで取得した個数の点：
%         lst=[];
%         for i=1:length(c_info)
%             point=c_info(i).Position
%             lst(end+1)=point
        point1=c_info(1).Position
        point2=c_info(2).Position 
        point3=c_info(3).Position
        point4=c_info(4).Position
        squre_points=[point1;point2;point3;point4]
        scatter3(point1(1,1),point1(1,2),point1(1,3),50,[0,0.6,1],'filled');
        scatter3(point2(1,1),point2(1,2),point2(1,3),50,[0,0.6,1],'filled');
        scatter3(point3(1,1),point3(1,2),point3(1,3),50,[0,0.6,1],'filled');
        scatter3(point4(1,1),point4(1,2),point4(1,3),50,[0,0.6,1],'filled');
        end
        %Set-SubGoal-point-button
        function  subgoal_point=SetSubGoalPointbutton_Callback(~,~)
            ans3 = inputdlg('Enter space-separated numbers:  ex)0 0 0',...
                'SubGoal_Point', [1 50]);
            subgoal_point = str2num(ans3{1});
            scatter3(subgoal_point(1),subgoal_point(2),subgoal_point(3),...
                50,[1,0,1],'filled');
        end%%function-end
        %Set-GoalPoint-button
        function goal_point=SetGoalPointbutton_Callback(~,~)
            ans2 = inputdlg('Enter space-separated numbers:  ex)0 0 0',...
                'Goal_Point', [1 50]);
            goal_point = str2num(ans2{1});
            scatter3(goal_point(1),goal_point(2),goal_point(3),50,[1,0,0],...
                'filled');
        end%%function-end
        function start_point=SetStartPointbutton_Callback()
            ans1 = inputdlg('Enter space-separated numbers:  ex)0 0 0',...
                'Start_Point', [1 50]);
            start_point = str2num(ans1{1});
            scatter3(start_point(1),start_point(2),start_point(3),...
                50,[0,0.6,1],'filled');
        end%%function-end
        
        
%         function STP(start_point)
%             ans1 = inputdlg('Enter space-separated numbers:  ex)0 0 0',...
%                 'Start_Point', [1 50]);
%             start_point = str2num(ans1{1});
%             scatter3(start_point(1),start_point(2),start_point(3),...
%                 50,[0,0.6,1],'filled');
%         end%%function-end
%         function a=print()
%             a=[0,1,2]
%         end
    end
end

