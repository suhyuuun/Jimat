<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<title>Jimat - Food choice for you</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD"
	crossorigin="anonymous" />
<script src="https://code.jquery.com/jquery-3.6.3.min.js"
	integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
	crossorigin="anonymous"></script>
<script src="https://kit.fontawesome.com/edd4d6d779.js"
	crossorigin="anonymous"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript"
	src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=952441bca7c2877c20d98599bb8b06bd"></script>
<link href="${path}/resources/css/main.css" type="text/css"
	rel="stylesheet" />
<link href="${path}/resources/css/map.css" type="text/css"
	rel="stylesheet" />
<link href="${path}/resources/css/food.css" type="text/css"
	rel="stylesheet" />
<script defer src="${path}/resources/js/main.js"></script>
<!--   <script defer src="${path}/resources/js/gps.js"></script> -->
<script defer src="${path}/resources/js/map.js"></script>
</head>
<body>

	<div class="body-wrap container col-12 column-row">
		<%-- 메인 메뉴 불러오기 --%>
		<div class="row">
			<jsp:include page="/WEB-INF/views/mainPage/mainMenu.jsp"></jsp:include>
		</div>

		<%-- 메인 지도 불러오기 --%>
		<div class="map_wrap col-12 mt-2 ms-3">
			<div id="map"></div>
		</div>

		<div class="shop-body col-12 container m-3">

			<!--  숍 리스트 표시 부분 -->
			<!-- <c:out value="${fn:length(aList)}" /> -->
			<div class="row row-cols-2 shop-list justify-content-between">
				<c:forEach var="aList" items="${aList}" varStatus="status" begin="1"
					end="14">
					<div class="shop-list-body col container d-flex p-0 mb-3">
						<div class="row">
							<div class="shop-list-info cols-7 columns-row ">
								<div class="row">
									<div class=" container d-flex">
										<div class="markerbg marker_<c:out value='${status.count}'/>"
											id="marker_<c:out value='${status.count}'/>"></div>
										<div class="shop-list-title">
											<p class="shop-list-title">${aList.foodstore_name}</p>
										</div>
									</div>
								</div>
								<p class="shop-list-category">${aList.food_category}</p>
								<p class="shop-list-address">${aList.address}</p>
								<p class="shop-list-phone">${aList.store_num}</p>
								<p class="shop-list-working">${aList.working_time}</p>
							</div>
						</div>
						<div class="shop-list-img cols-4">

							<c:url var="shopDetail_a" value="shopdetail.do">
								<c:param name="shopDetail_num" value="${aList.foodstore_id}" />
							</c:url>
							<a href="${shopDetail_a}"> <img src="${aList.img_url}"
								class="shop-thumbnail" /></a>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
		<!-- 지도타입 컨트롤 div 입니다 
		<div class="custom_typecontrol radius_border">
			<span id="btnRoadmap" class="selected_btn"
				onclick="setMapType('roadmap')">지도</span> <span id="btnSkyview"
				class="btn" onclick="setMapType('skyview')"> 스카이뷰</span>
		</div> -->

		<!-- 지도 확대, 축소 컨트롤 div 입니다 -->
		<div class="custom_zoomcontrol radius_border">
			<span onclick="zoomIn()"><i class="fa-solid fa-plus fa-lg"></i></span>
			<span onclick="zoomOut()"><i class="fa-solid fa-minus fa-lg"></i></span>
		</div>
	</div>
	<!-- <script defer src="${path}/resources/js/map.body.js?v=3"></script> -->
	<script>
	var infowindow2 = new daum.maps.InfoWindow({
		removable : true,
		zIndex : 1
	});
	function displayInfowindow2(marker, foodstore_name, food_category) {
		var content = '<div class ="f_main" >' + '<div class="f_header" style="text-align:left; font-weight: 900;" >' + foodstore_name +'</div>'
	    + '<div id="f_food_category" style="text-align:left">' + food_category
		+ '</div>' +  '</div>';
		// content의 내용을 인포윈도우에 등록
		infowindow2.setContent(content);
		infowindow2.setPosition(marker.position);
		infowindow2.open(map, marker);
	}
	function addMarker2(position, idx, title) {
		var imageSrc ='https://i1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커
		// 이미지
		// url,
		// 스프라이트
		// 이미지를
		// 씁니다
		imageSize = new daum.maps.Size(40, 40), // 마커 이미지의 크기
		imgOptions = {
			spriteSize : new daum.maps.Size(36, 691), // 스프라이트 이미지의 크기
			spriteOrigin : new daum.maps.Point(0, (idx * 46) + 10), // 스프라이트 이미지 중
			// 사용할 영역의 좌상단
			// 좌표
			offset : new daum.maps.Point(12, 37)
		// 마커 좌표에 일치시킬 이미 내에서의 좌표지
		}, markerImage = new daum.maps.MarkerImage(imageSrc, imageSize, imgOptions), marker = new daum.maps.Marker(
				{
					position : position, // 마커의 위치
					image : markerImage,
					clickable : true
				});

		marker.setMap(map); // 지도 위에 마커를 표출합니다
		markers.push(marker); // 배열에 생성된 마커를 추가합니다

		return marker;
	}

	var mapContainer = document.getElementById('map'), // 지도를 표시할 div
	mapOption = {
		center : new daum.maps.LatLng(38.5050639,127.0553532), // 지도의 중심좌표
		level : 5
	// 지도의 확대 레벨
	};

	// 지도를 생성합니다
	var map = new daum.maps.Map(mapContainer, mapOption);
	var bounds = new daum.maps.LatLngBounds();
	var placePosition;
	var markers = [];
<c:set var="count" value="0" />
<c:forEach var="aList" items="${aList}" varStatus="status" begin="1"
	end="14">
	placePosition = new daum.maps.LatLng(${aList.latitude},${aList.longitude});
	marker = addMarker2(placePosition, ${count}, "${aList.foodstore_name}");
	daum.maps.event.addListener(marker, 'click', function() {
		displayInfowindow2(marker, "${aList.foodstore_name}", "${aList.food_category}");
	});
	bounds.extend(placePosition);
<c:set var="count" value="${count + 1}" />
</c:forEach>
	daum.maps.event.addListener(map, 'click', function() {
		infowindow.close();
	});
	map.setBounds(bounds);
	</script>
	<script type="text/javascript">
		//displayPlaces(<c:out value="${param.keyword}" />);
	</script>
</body>
</html>