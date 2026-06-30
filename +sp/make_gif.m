function gif = make_gif(gif,filename,delay_time)

F=getframe(gcf);
I=frame2im(F);
[I,map]=rgb2ind(I,256);
if gif.gif_pic_num == 1
    imwrite(I,map,filename,'gif','Loopcount',inf,'DelayTime',delay_time);
else
    imwrite(I,map,filename,'gif','WriteMode','append','DelayTime',delay_time);
end
gif.gif_pic_num = gif.gif_pic_num + 1;

end