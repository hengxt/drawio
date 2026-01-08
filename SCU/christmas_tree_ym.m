function christmas_tree_ym()
  
    STYLE_ID = 2; % 1:经典, 2:冰雪, 3:橄榄, 4:彩色, 5:黑白, 6:粉色

    hex2rgb = @(hexStr) reshape(sscanf(char(strrep(string(hexStr),'#','')),'%2x')/255, 1, 3);
    
    styles = { ...
        struct('bg', '#050505', 'tree', {{'#0f3d0f', '#144514', '#006400', '#2E8B57', '#228B22'}}, 'trunk', '#3e2723', 'decor', {{'#FFD700', '#FF0000', '#FFFFFF', '#FFA500'}}, 'star', '#FFD700', 'text', '#FFD700', 'ribbon', '#D4AF37', 'snow', '#FFFFFF', 'ribbon_w', 2.2), ...
        struct('bg', '#0a1014', 'tree', {{'#2F4F4F', '#5F9EA0', '#708090'}}, 'trunk', '#404040', 'decor', {{'#E0FFFF', '#FFFFFF', '#B0C4DE'}}, 'star', '#E0FFFF', 'text', '#B0C4DE', 'ribbon', '#F0FFFF', 'snow', '#F0FFFF', 'ribbon_w', 1.5), ...
        struct('bg', '#1a1a1a', 'tree', {{'#556B2F', '#6B8E23', '#808000'}}, 'trunk', '#5D4037', 'decor', {{'#CD853F', '#FFCC00'}}, 'star', '#FFCC00', 'text', '#DEB887', 'ribbon', '#000000', 'snow', '#FFFFFF', 'ribbon_w', 0), ...
        struct('bg', '#000000', 'tree', {{'#006400', '#228B22'}}, 'trunk', '#4E342E', 'decor', {{'#FF0000', '#00FF00', '#0000FF', '#FFFF00'}}, 'star', '#FFD700', 'text', '#FF6347', 'ribbon', '#C0C0C0', 'snow', '#FFFFFF', 'ribbon_w', 1.5), ...
        struct('bg', '#000000', 'tree', {{'#1a1a1a', '#222222', '#333333'}}, 'trunk', '#111111', 'decor', {{'#FFFFFF', '#DDDDDD'}}, 'star', '#FFFFFF', 'text', '#FFFFFF', 'ribbon', '#FFFFFF', 'snow', '#808080', 'ribbon_w', 1.2), ...
        struct('bg', '#120508', 'tree', {{'#D87093', '#FF69B4', '#C71585'}}, 'trunk', '#5D4037', 'decor', {{'#FFFFFF', '#FFD700', '#FF1493'}}, 'star', '#FFD700', 'text', '#FFC0CB', 'ribbon', '#FFB6C1', 'snow', '#FFF0F5', 'ribbon_w', 1.5) ...
    };
    cfg_raw = styles{STYLE_ID};

    bgColor = hex2rgb(cfg_raw.bg);
    hFig = figure('Color', bgColor, 'Position', [200, 50, 750, 850], 'MenuBar', 'none', 'ToolBar', 'none', 'Name', 'Merry Christmas');
    ax = axes('Parent', hFig, 'Color', 'none', 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none');
    hold on; axis equal;
    set(ax, 'XLim', [-1.4, 1.4], 'YLim', [-1.0, 1.7]);

    % 树体
    data = []; % [x, y, z, r, g, b, size, isStar]
    n_layers = 8; layer_gap = 0.04;
    layer_heights = linspace(-0.5, 1.25, n_layers + 1);
    
    % 树干
    n_trunk = 2500;
    th = -0.8 + (0.6)*rand(n_trunk,1);
    tr = 0.28 * rand(n_trunk,1); tt = 2*pi*rand(n_trunk,1);
    data = [data; tr.*cos(tt), th, tr.*sin(tt), repmat(hex2rgb(cfg_raw.trunk), n_trunk,1), 12*ones(n_trunk,1), zeros(n_trunk,1)];

    % 树叶、装饰与丝带
    for i = 1:n_layers
        h_min = layer_heights(i) + layer_gap;
        h_max = layer_heights(i+1) - layer_gap;
        if i == n_layers
            h_min = layer_heights(i) + layer_gap * 0.3;
            h_max = layer_heights(end) + 0.28 - 0.02;
            num_l = 1200;
        else
            num_l = 1000;
        end
        rel_h_layer = (i-1)/(n_layers-1);
        max_r = 1.6 * (1.0 - rel_h_layer * 0.8);
        
        for j = 1:num_l
            h = h_min + (h_max-h_min)*rand();
            rel_h_in = (h-h_min)/(h_max-h_min);
            if i == n_layers
                r = max_r * (1.0-rel_h_in) * sqrt(0.05 + 0.95*rand());
                c = hex2rgb(cfg_raw.tree{randi(length(cfg_raw.tree))});
                if rel_h_in > 0.85 && rand() < (rel_h_in-0.85)/0.15 * 0.3, c = hex2rgb(cfg_raw.star); end
            else
                dist_c = abs(h - (h_min+h_max)/2) / (h_max-h_min) * 2;
                r = max_r * (1.0 - dist_c^2 * 0.3) * sqrt(0.1 + 0.9*rand());
                c = hex2rgb(cfg_raw.tree{randi(length(cfg_raw.tree))});
            end
            t = 2*pi*rand();
            data = [data; r*cos(t), h, r*sin(t), c, 6+10*rand(), 0];
        end
        
        % 装饰
        for j = 1:floor(600/n_layers)
            h = (h_min+0.01) + (h_max-h_min-0.02)*rand();
            r = max_r * (1.0-((h-h_min)/(h_max-h_min))) * 0.98;
            if i < n_layers, r = max_r * (1.0 - (abs(h-(h_min+h_max)/2)/(h_max-h_min)*2)^2 * 0.3) * 0.98; end
            t = 2*pi*rand();
            data = [data; r*cos(t), h, r*sin(t), hex2rgb(cfg_raw.decor{randi(length(cfg_raw.decor))}), 30+20*rand(), 0];
        end
        
        % 丝带
        if cfg_raw.ribbon_w > 0
            n_rib = 150;
            h_vals = linspace(h_max, h_min, n_rib);
            t_vals = linspace(0, 1.5*pi, n_rib) + (i*pi*0.7);
            for j = 1:n_rib
                curr_r = max_r * (1.0-((h_vals(j)-h_min)/(h_max-h_min))) + 0.08;
                if i < n_layers, curr_r = max_r * (1.0 - (abs(h_vals(j)-(h_min+h_max)/2)/(h_max-h_min)*2)^2 * 0.3) + 0.08; end
                data = [data; curr_r*cos(t_vals(j)), h_vals(j), curr_r*sin(t_vals(j)), hex2rgb(cfg_raw.ribbon), 8*cfg_raw.ribbon_w, 0];
            end
        end
    end
    % 星星本体
    star_h = layer_heights(end) + 0.28;
    data = [data; 0, star_h, 0, hex2rgb(cfg_raw.star), 500, 1];

    % 雪花
    n_snow = 500;
    snow = [(rand(n_snow,1)-0.5)*4.5, rand(n_snow,1)*2.5-1, (rand(n_snow,1)-0.5)*4.5];
    snowColor = hex2rgb(cfg_raw.snow);

    % 渲染
    hMain = scatter(0,0,10,[1 1 1],'filled'); 
    hStar = scatter(0,0,500,hex2rgb(cfg_raw.star),'p','filled','MarkerEdgeColor','none'); 
    hGlow = [scatter(0,0,800,hex2rgb(cfg_raw.star),'filled','MarkerFaceAlpha',0.15), ...
             scatter(0,0,500,hex2rgb(cfg_raw.star),'filled','MarkerFaceAlpha',0.25), ...
             scatter(0,0,300,hex2rgb(cfg_raw.star),'filled','MarkerFaceAlpha',0.35)];
    hSnow = scatter(zeros(n_snow,1),zeros(n_snow,1),10,snowColor,'filled','MarkerFaceAlpha',0.6);

    text(0, 1.25, 'Merry Christmas', 'Color', hex2rgb(cfg_raw.text), 'FontSize', 42, ...
        'FontName', 'Brush Script MT', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');

    camera_dist = 5.0; 
    frame = 0;
    
    while ishandle(hFig)
        frame = frame + 1;
        angle = frame * 0.01;
        cosA = cos(angle); sinA = sin(angle);
        
        % 树体投影
        rotZ = data(:,1)*sinA + data(:,3)*cosA;
        depth_f = 1.0 ./ (camera_dist - rotZ);
        depth_f = max(0.01, depth_f); 
        
        rotX = data(:,1)*cosA - data(:,3)*sinA;
        [~, idx] = sort(rotZ, 'ascend');
        
        treeIdx = data(idx, 8) == 0;
        starIdx = data(idx, 8) == 1;
        
        % 更新树
        hMain.XData = rotX(idx(treeIdx)) .* depth_f(idx(treeIdx)) * 3.5;
        hMain.YData = data(idx(treeIdx),2) .* depth_f(idx(treeIdx)) * 3.5;
        hMain.SizeData = data(idx(treeIdx),7) .* depth_f(idx(treeIdx)) * 6;
        hMain.CData = data(idx(treeIdx),4:6);
        
        % 更新星星
        sx = rotX(idx(starIdx)) * depth_f(idx(starIdx)) * 3.5;
        sy = data(idx(starIdx),2) * depth_f(idx(starIdx)) * 3.5;
        sd = depth_f(idx(starIdx));
        hStar.XData = sx; hStar.YData = sy; hStar.SizeData = 500 * sd * 3.5;
        for k=1:3, hGlow(k).XData = sx; hGlow(k).YData = sy; hGlow(k).SizeData = (900-k*200)*sd*3.5; end
        
        % 更新雪花
        snow(:,2) = snow(:,2) - 0.015;
        snow(snow(:,2) < -1.1, 2) = 1.6;
        srotZ = snow(:,1)*sinA + snow(:,3)*cosA;
        sdepth = max(0.01, 1.0 ./ (camera_dist - srotZ));
        srotX = snow(:,1)*cosA - snow(:,3)*sinA;
        
        hSnow.XData = srotX .* sdepth * 3.5;
        hSnow.YData = snow(:,2) .* sdepth * 3.5;
        hSnow.SizeData = max(0.1, 8 * sdepth * 3.5);
        
        drawnow limitrate;
        pause(0.02);
    end
end