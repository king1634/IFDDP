<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>마포구 WMS + 주요 시설물 마커(OpenLayers)</title>

  <!-- OpenLayers CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@7.5.2/ol.css">
  <style>
    body { margin:0; font-family:system-ui; }
    #map { width:100%; height:600px; }
    .tooltip {
      position: absolute;
      background: rgba(0,0,0,0.7);
      color: #fff;
      padding: 4px 8px;
      border-radius: 4px;
      white-space: nowrap;
      font-size: 13px;
      pointer-events: none;
      transform: translate(-50%, -100%);
    }
  </style>
</head>
<body>
  <h2>마포구 행정동 + 주요 시설물 마커 (마우스 오버 이름 표시)</h2>
  <div id="map"></div>

  <!-- OpenLayers JS -->
  <script src="https://cdn.jsdelivr.net/npm/ol@7.5.2/dist/ol.js"></script>
  <script>
    // 1) GeoServer WMS 레이어
    const wmsLayer = new ol.layer.Image({
      source: new ol.source.ImageWMS({
        url: 'http://localhost:8081/geoserver/mapo/wms',
        params: { LAYERS: 'mapo:F_FAC_BUILDING_11440_202508', TILED: true },
        serverType: 'geoserver',
        crossOrigin: 'anonymous'
      })
    });

    // 2) 마커 좌표 정의
    const stadiumCoord = ol.proj.fromLonLat([126.8963, 37.5683]);   // 상암월드컵경기장
    const mapoOfficeCoord = ol.proj.fromLonLat([126.9034, 37.5664]); // 마포구청사
    const hongikCoord = ol.proj.fromLonLat([126.9253, 37.5514]);     // 홍익대학교 본관

    // 3) 마커 생성
    const features = [];

    // 상암월드컵경기장 (빨간색)
    features.push(new ol.Feature({
      geometry: new ol.geom.Point(stadiumCoord),
      name: "상암월드컵경기장",
      color: "red"
    }));

    // 마포구청사 (노란색)
    features.push(new ol.Feature({
      geometry: new ol.geom.Point(mapoOfficeCoord),
      name: "마포구청사",
      color: "yellow"
    }));

    // 홍익대학교 본관 (파란색)
    features.push(new ol.Feature({
      geometry: new ol.geom.Point(hongikCoord),
      name: "홍익대학교 본관",
      color: "blue"
    }));

    // 4) 마커 스타일 함수
    const markerStyle = function(feature) {
      return new ol.style.Style({
        image: new ol.style.Circle({
          radius: 7,
          fill: new ol.style.Fill({color: feature.get('color') || 'red'}),
          stroke: new ol.style.Stroke({color: 'white', width: 2})
        })
      });
    };

    // 5) 마커 레이어
    const markerLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        features: features
      }),
      style: markerStyle
    });

    // 6) 지도 생성
    const map = new ol.Map({
      target: 'map',
      layers: [
        new ol.layer.Tile({ source: new ol.source.OSM() }), // 배경지도
        wmsLayer,
        markerLayer
      ],
      view: new ol.View({
        center: ol.proj.fromLonLat([126.91, 37.56]), // 마포구 중심
        zoom: 13
      })
    });

    // 7) 툴팁(마우스 오버 시 표시)
    const tooltip = document.createElement('div');
    tooltip.className = 'tooltip';
    tooltip.style.display = 'none';
    document.body.appendChild(tooltip);

    map.on('pointermove', function(evt) {
      const feature = map.forEachFeatureAtPixel(evt.pixel, function(feature) {
        return feature;
      });

      if (feature) {
        const coordinates = feature.getGeometry().getCoordinates();
        const pixel = map.getPixelFromCoordinate(coordinates);
        tooltip.style.left = pixel[0] + 'px';
        tooltip.style.top = pixel[1] + 'px';
        tooltip.innerHTML = feature.get('name');
        tooltip.style.display = 'block';
      } else {
        tooltip.style.display = 'none';
      }
    });
    
/* 	 // 8) GeoJSON 벡터 레이어 추가
	const geojsonLayer = new ol.layer.Vector({
	  source: new ol.source.Vector({
	    url: '/data/mapoDong.geojson',
	    format: new ol.format.GeoJSON({
	      dataProjection: 'EPSG:4326',      // GeoJSON 좌표계
	      featureProjection: 'EPSG:3857'    // OpenLayers 지도 좌표계
	    })
	  }),
	  style: new ol.style.Style({
	    stroke: new ol.style.Stroke({
	      color: '#FF0000',
	      width: 2
	    }),
	    fill: new ol.style.Fill({
	      color: 'rgba(255,0,0,0.1)'
	    })
	  })
	});

    // 지도에 추가
    map.addLayer(geojsonLayer); */
  </script>
</body>
</html>