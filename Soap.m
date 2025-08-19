function soap_bubble_interference()
    % 创建主窗口
    fig = figure('Name', '肥皂泡干涉模拟', 'Position', [100, 100, 1200, 700]);
    
    % 创建参数面板
    panel = uipanel('Parent', fig, 'Title', '参数控制', 'Position', [0.01, 0.01, 0.28, 0.98]);
    
    % 创建绘图区域
    ax = axes('Parent', fig, 'Position', [0.33, 0.1, 0.65, 0.8]);
    
    % 创建干涉分辨率显示文本
    resolution_text = uicontrol('Parent', fig, 'Style', 'text', ...
        'Units', 'normalized', 'Position', [0.33, 0.92, 0.65, 0.05], ...
        'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [0.9 0.9 0.9]);
    
    % 初始参数设置
    params = struct();
    params.n1 = 1; % 空气折射率 (固定值)
    params.n2 = 1.3; % 肥皂液折射率
    params.thick_top = 300e-9; % 肥皂膜顶部厚度[m]
    params.thick_bottom = 900e-9; % 肥皂膜底部厚度[m]
    params.height = 100e-3; % 肥皂膜高度[m]
    params.num_lambda = 7; % 波长数量
    params.num_thickness = 10001; % 厚度划分份数 (固定值)
    params.lambda_start = 380e-9; % 起始波长 (固定值)
    params.lambda_end = 780e-9; % 结束波长 (固定值)
    params.theta_in = 45; % 入射角[°]
    params.view_range = 1; % 视野范围倍数 (1 = 默认视野, 30 = 30倍视野)
    params.y_min = 0; % Y轴最小值 (固定值)
    params.y_max = 1; % Y轴最大值 (固定值)
    % 干涉参数
    params.reflectivity = 0.04; % 界面反射率（空气/肥皂液界面的典型值）
    
    % 创建滚动面板以容纳所有控件
    scroll_panel = uipanel('Parent', panel, 'BorderType', 'none', ...
        'Position', [0, 0, 1, 1]);
    
    % 控件垂直位置计算
    base_y = 0.98;
    label_height = 0.025;
    control_height = 0.03;
    gap = 0.01;
    
    % 膜厚参数组
    y = base_y;
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '肥皂膜厚度参数 (nm):', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.9, label_height], ...
        'HorizontalAlignment', 'left', 'FontWeight', 'bold');
    y = y - label_height - gap;
    
    % 顶部厚度控件
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '顶部厚度:', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.4, control_height], ...
        'HorizontalAlignment', 'left');
    slider_top = uicontrol('Parent', scroll_panel, 'Style', 'slider', ...
        'Min', 50, 'Max', 1000, 'Value', params.thick_top*1e9, ...
        'Units', 'normalized', 'Position', [0.05, y-control_height, 0.6, control_height], ...
        'SliderStep', [0.01 0.1]);
    edit_top = uicontrol('Parent', scroll_panel, 'Style', 'edit', ...
        'String', num2str(params.thick_top*1e9), ...
        'Units', 'normalized', 'Position', [0.7, y-control_height, 0.25, control_height]);
    y = y - control_height*2 - gap;
    
    % 底部厚度控件
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '底部厚度:', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.4, control_height], ...
        'HorizontalAlignment', 'left');
    slider_bottom = uicontrol('Parent', scroll_panel, 'Style', 'slider', ...
        'Min', 100, 'Max', 2000, 'Value', params.thick_bottom*1e9, ...
        'Units', 'normalized', 'Position', [0.05, y-control_height, 0.6, control_height], ...
        'SliderStep', [0.01 0.1]);
    edit_bottom = uicontrol('Parent', scroll_panel, 'Style', 'edit', ...
        'String', num2str(params.thick_bottom*1e9), ...
        'Units', 'normalized', 'Position', [0.7, y-control_height, 0.25, control_height]);
    y = y - control_height*2 - gap*2;
    
    % 几何和入射参数组
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '几何和入射参数:', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.9, label_height], ...
        'HorizontalAlignment', 'left', 'FontWeight', 'bold');
    y = y - label_height - gap;
    
    % 膜高度控件
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '膜高度 (mm):', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.4, control_height], ...
        'HorizontalAlignment', 'left');
    slider_height = uicontrol('Parent', scroll_panel, 'Style', 'slider', ...
        'Min', 10, 'Max', 500, 'Value', params.height*1e3, ...
        'Units', 'normalized', 'Position', [0.05, y-control_height, 0.6, control_height], ...
        'SliderStep', [0.01 0.1]);
    edit_height = uicontrol('Parent', scroll_panel, 'Style', 'edit', ...
        'String', num2str(params.height*1e3), ...
        'Units', 'normalized', 'Position', [0.7, y-control_height, 0.25, control_height]);
    y = y - control_height*2 - gap;
    
    % 入射角控件
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '入射角 (°):', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.4, control_height], ...
        'HorizontalAlignment', 'left');
    slider_theta = uicontrol('Parent', scroll_panel, 'Style', 'slider', ...
        'Min', 0, 'Max', 80, 'Value', params.theta_in, ...
        'Units', 'normalized', 'Position', [0.05, y-control_height, 0.6, control_height], ...
        'SliderStep', [0.01 0.1]);
    edit_theta = uicontrol('Parent', scroll_panel, 'Style', 'edit', ...
        'String', num2str(params.theta_in), ...
        'Units', 'normalized', 'Position', [0.7, y-control_height, 0.25, control_height]);
    y = y - control_height*2 - gap*2;
    
    % 光学参数组
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '光学参数:', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.9, label_height], ...
        'HorizontalAlignment', 'left', 'FontWeight', 'bold');
    y = y - label_height - gap;
    
    % 肥皂液折射率控件
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '肥皂液折射率:', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.4, control_height], ...
        'HorizontalAlignment', 'left');
    slider_n2 = uicontrol('Parent', scroll_panel, 'Style', 'slider', ...
        'Min', 1.1, 'Max', 1.8, 'Value', params.n2, ...
        'Units', 'normalized', 'Position', [0.05, y-control_height, 0.6, control_height], ...
        'SliderStep', [0.01 0.1]);
    edit_n2 = uicontrol('Parent', scroll_panel, 'Style', 'edit', ...
        'String', num2str(params.n2), ...
        'Units', 'normalized', 'Position', [0.7, y-control_height, 0.25, control_height]);
    y = y - control_height*2 - gap*2;
    
    % 波长数量控件
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '波长数量:', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.4, control_height], ...
        'HorizontalAlignment', 'left');
    slider_num_lambda = uicontrol('Parent', scroll_panel, 'Style', 'slider', ...
        'Min', 3, 'Max', 15, 'Value', params.num_lambda, ...
        'Units', 'normalized', 'Position', [0.05, y-control_height, 0.6, control_height], ...
        'SliderStep', [1/12 2/12]);
    edit_num_lambda = uicontrol('Parent', scroll_panel, 'Style', 'edit', ...
        'String', num2str(params.num_lambda), ...
        'Units', 'normalized', 'Position', [0.7, y-control_height, 0.25, control_height]);
    y = y - control_height*2 - gap*2;
    
    % 干涉参数组
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '干涉分辨率参数:', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.9, label_height], ...
        'HorizontalAlignment', 'left', 'FontWeight', 'bold', 'BackgroundColor', [0.9 0.8 0.8]);
    y = y - label_height - gap;
    
    % 界面反射率控件
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '界面反射率:', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.4, control_height], ...
        'HorizontalAlignment', 'left');
    slider_reflectivity = uicontrol('Parent', scroll_panel, 'Style', 'slider', ...
        'Min', 0.01, 'Max', 0.2, 'Value', params.reflectivity, ...
        'Units', 'normalized', 'Position', [0.05, y-control_height, 0.6, control_height], ...
        'SliderStep', [0.01 0.05]);
    edit_reflectivity = uicontrol('Parent', scroll_panel, 'Style', 'edit', ...
        'String', num2str(params.reflectivity), ...
        'Units', 'normalized', 'Position', [0.7, y-control_height, 0.25, control_height]);
    y = y - control_height*2 - gap*2;
    
    % 绘制范围控制
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '图像显示控制:', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.9, label_height], ...
        'HorizontalAlignment', 'left', 'FontWeight', 'bold', 'BackgroundColor', [0.9 0.9 0.6]);
    y = y - label_height - gap;
    
    % 绘制范围控件 - 可以扩展绘制区域至少30倍
    uicontrol('Parent', scroll_panel, 'Style', 'text', 'String', '绘制范围 (倍数):', ...
        'Units', 'normalized', 'Position', [0.05, y, 0.4, control_height], ...
        'HorizontalAlignment', 'left');
    slider_range = uicontrol('Parent', scroll_panel, 'Style', 'slider', ...
        'Min', 1, 'Max', 30, 'Value', params.view_range, ...
        'Units', 'normalized', 'Position', [0.05, y-control_height, 0.6, control_height], ...
        'SliderStep', [0.05 0.2], 'BackgroundColor', [0.9 0.9 1]);
    edit_range = uicontrol('Parent', scroll_panel, 'Style', 'edit', ...
        'String', num2str(params.view_range), ...
        'Units', 'normalized', 'Position', [0.7, y-control_height, 0.25, control_height]);
    y = y - control_height*2 - gap*3;
    
    % 计算按钮 - 放在底部，确保不会与其他控件重叠
    btn_calc = uicontrol('Parent', scroll_panel, 'Style', 'pushbutton', 'String', '计算干涉图', ...
        'Units', 'normalized', 'Position', [0.25, y, 0.5, 0.06], 'FontWeight', 'bold', ...
        'BackgroundColor', [0.8 0.9 0.8], 'FontSize', 10);
    
    % 设置控件回调函数
    set(slider_top, 'Callback', @(src,event) slider_callback(src, edit_top, false));
    set(edit_top, 'Callback', @(src,event) edit_callback(src, slider_top, 50, 1000, false));
    
    set(slider_bottom, 'Callback', @(src,event) slider_callback(src, edit_bottom, false));
    set(edit_bottom, 'Callback', @(src,event) edit_callback(src, slider_bottom, 100, 2000, false));
    
    set(slider_height, 'Callback', @(src,event) slider_height_callback(src, edit_height, slider_range, false));
    set(edit_height, 'Callback', @(src,event) edit_height_callback(src, slider_height, slider_range, 10, 500, false));
    
    set(slider_theta, 'Callback', @(src,event) slider_callback(src, edit_theta, false));
    set(edit_theta, 'Callback', @(src,event) edit_callback(src, slider_theta, 0, 80, false));
    
    set(slider_n2, 'Callback', @(src,event) slider_callback(src, edit_n2, false));
    set(edit_n2, 'Callback', @(src,event) edit_callback(src, slider_n2, 1.1, 1.8, false));
    
    set(slider_num_lambda, 'Callback', @(src,event) slider_callback(src, edit_num_lambda, true));
    set(edit_num_lambda, 'Callback', @(src,event) edit_callback(src, slider_num_lambda, 3, 15, true));
    
    set(slider_reflectivity, 'Callback', @(src,event) slider_callback(src, edit_reflectivity, false));
    set(edit_reflectivity, 'Callback', @(src,event) edit_callback(src, slider_reflectivity, 0.01, 0.2, false));
    
    set(slider_range, 'Callback', @(src,event) slider_callback(src, edit_range, false));
    set(edit_range, 'Callback', @(src,event) edit_callback(src, slider_range, 1, 30, false));
    
    % 设置计算按钮的回调函数
    set(btn_calc, 'Callback', @(src,event) update_plot(ax, resolution_text, ...
        params.n1, get(slider_n2, 'Value'), ...
        get(slider_top, 'Value')*1e-9, get(slider_bottom, 'Value')*1e-9, ...
        get(slider_height, 'Value')*1e-3, round(get(slider_num_lambda, 'Value')), ...
        params.num_thickness, params.lambda_start, ...
        params.lambda_end, get(slider_theta, 'Value'), ...
        get(slider_range, 'Value'), params.y_min, params.y_max, ...
        get(slider_reflectivity, 'Value')));
    
    % 初始化绘图
    update_plot(ax, resolution_text, params.n1, params.n2, params.thick_top, params.thick_bottom, ...
        params.height, params.num_lambda, params.num_thickness, ...
        params.lambda_start, params.lambda_end, params.theta_in, ...
        params.view_range, params.y_min, params.y_max, ...
        params.reflectivity);
end

function slider_callback(slider, edit, isInteger)
    value = get(slider, 'Value');
    if isInteger
        value = round(value);
        set(slider, 'Value', value);
    end
    set(edit, 'String', num2str(value));
end

% 特殊的膜高度滑块回调，同时更新滑块和视野范围最大值
function slider_height_callback(slider, edit, range_slider, isInteger)
    value = get(slider, 'Value');
    if isInteger
        value = round(value);
        set(slider, 'Value', value);
    end
    set(edit, 'String', num2str(value));
end

% 特殊的膜高度编辑框回调
function edit_height_callback(edit, slider, range_slider, minValue, maxValue, isInteger)
    value = str2double(get(edit, 'String'));
    if isnan(value)
        % 如果输入无效，恢复为滑块的当前值
        set(edit, 'String', num2str(get(slider, 'Value')));
        return;
    end
    
    % 限制在有效范围内
    value = max(minValue, min(maxValue, value));
    if isInteger
        value = round(value);
    end
    
    set(edit, 'String', num2str(value));
    set(slider, 'Value', value);
end

function edit_callback(edit, slider, minValue, maxValue, isInteger)
    value = str2double(get(edit, 'String'));
    if isnan(value)
        % 如果输入无效，恢复为滑块的当前值
        set(edit, 'String', num2str(get(slider, 'Value')));
        return;
    end
    
    % 限制在有效范围内
    value = max(minValue, min(maxValue, value));
    if isInteger
        value = round(value);
    end
    
    set(edit, 'String', num2str(value));
    set(slider, 'Value', value);
end

function update_plot(ax, resolution_text, n1, n2, thick_top, thick_bottom, height, num_lambda, num_thickness, lambda_start, lambda_end, theta_in, view_range, y_min, y_max, reflectivity)
    % 计算扩展后的高度范围 - 根据视野范围扩展计算区域
    extended_height = height * view_range;
    
    % 生成计算变量 - 注意thickness和h数组都扩展了
    lambda = linspace(lambda_end, lambda_start, num_lambda); % 波长数组
    
    % 为了保持原始厚度渐变率，按比例扩展厚度变化范围
    thickness_range = thick_top - thick_bottom; 
    extended_thickness_bottom = thick_bottom;
    extended_thickness_top = thick_bottom + thickness_range * view_range;
    thickness = linspace(extended_thickness_bottom, extended_thickness_top, num_thickness); % 扩展的厚度数组
    
    h = linspace(0, extended_height, num_thickness); % 扩展的高度数组
    delta = zeros(num_lambda, num_thickness); % 光程差数组
    dfai = zeros(num_lambda, num_thickness); % 相位差数组
    I = zeros(num_lambda, num_thickness); % 光强数组
    theta_in_rad = theta_in * pi / 180; % 转换成弧度制
    
    % 计算折射角
    theta_2 = asin(n1 * sin(theta_in_rad) / n2);
    
    % 计算每个厚度对应的光强
    for i = 1:num_lambda
        for j = 1:num_thickness
            delta(i,j) = 2 * n2 * thickness(j) * cos(theta_2); % 计算光程差
            dfai(i,j) = delta(i,j) / lambda(i) + pi; % 计算相位差
        end
    end
    
    I = 4 * (cos(dfai/2)).^2; % 计算相位差对应的光强
    I0 = max(max(I)); % 归一化系数
    
    % 清除之前的图形
    cla(ax);
    
    % 绘制新图形
    cmap = colormap(ax, hsv(num_lambda)); % 使用hsv根据波长数量形成彩虹渐变
    hold(ax, 'on');
    
    for i = 1:num_lambda
        name = "波长 = " + num2str(round(lambda(i)*1e9)) + " nm";
        plot(ax, h*1e3, I(i,:)/I0, 'LineWidth', 1.5, 'Color', cmap(i, :), 'DisplayName', name);
    end
    
    % 计算干涉分辨率
    % 使用法布里-珀罗干涉仪的分辨率公式: R = λ/Δλ = mF
    % 其中m是干涉级次，F是精细度
    % 对于肥皂泡薄膜，干涉级次m = 2*n2*thickness/lambda
    finesse = pi * sqrt(reflectivity) / (1 - reflectivity); % 精细度
    
    % 计算平均波长和平均膜厚
    avg_lambda = mean(lambda);
    avg_thickness = mean(thickness);
    
    % 计算干涉级次
    interference_order = 2 * n2 * avg_thickness / avg_lambda;
    
    % 计算分辨率
    resolution = interference_order * finesse;
    delta_lambda = avg_lambda / resolution;
    
    % 更新干涉分辨率显示
    resolution_str = sprintf('实时干涉分辨率: R = λ/Δλ = %.1f, 在波长 %.1f nm 处可分辨最小波长差: Δλ = %.3f nm', ...
        resolution, avg_lambda*1e9, delta_lambda*1e9);
    set(resolution_text, 'String', resolution_str);
    
    % 设置图形属性
    xlabel(ax, "高度（mm）");
    ylabel(ax, "归一化光强I/I0");
    title(ax, sprintf("肥皂膜干涉条纹色散曲线 (%.1f倍视野)\n顶部厚度: %.0f nm, 底部厚度: %.0f nm, 入射角: %.1f°", ...
        view_range, thick_top*1e9, thick_bottom*1e9, theta_in));
    legend(ax, 'Location', 'best');
    grid(ax, 'on');
    
    % 显示完整扩展后的范围
    xlim(ax, [0, extended_height*1e3]);
    ylim(ax, [y_min, y_max]);
    
    hold(ax, 'off');
    
    % 更新图形
    drawnow;
end
