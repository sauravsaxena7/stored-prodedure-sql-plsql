SELECT * FROM CorporatePlan where CorporatePlanId=2003
SELECT * FROM Member where MemberId=3047663
SELECT * FROM UserLogin WHERE UserLoginId=5012889
SELECT * FROM MemberPlan WHERE MemberId=3047663 and CorporatePlanId=2003
SELECT * FROM MemberPlanDetails where MemberPlanId=6486291
SELECT * FROM Appointment where caseNo='HA07022024DFFDFC'
SELECT * FROM AppointmentDetails where AppointmentId=355352

SELECT * FROM MemberPlanDetails where MemberPlanId in (SELECT MemberPlanId FROM MemberPlan where MemberId in(select  MemberId from appointment  where userloginid in (select userloginid from UserLogin where username in ('1646158@bundle.com',
'1645798@bundle.com',
'1645971@bundle.com',
'1645774@bundle.com',
'1645857@bundle.com',
'1728524@bundle.com',
'1234679@bundle.com',
'1646093@bundle.com',
'1645986@bundle.com',
'1645859@bundle.com',
'1645835@bundle.com',
'1645958@bundle.com',
'1645906@bundle.com',
'1621405@bundlha.in',
'1621563@bundlha.in',
'1621542@bundlha.in',
'1625463@bundlha.in',
'1626378@bundlha.in',
'1629842@bundlha.in',
'1631414@bundlha.in',
'1630995@bundlha.in',
'1630810@bundlha.in',
'1631504@bundlha.in',
'1631476@bundlha.in',
'1631449@bundlha.in',
'1633473@bundlha.in',
'1634378@bundlha.in',
'1635355@bundlha.in',
'1637643@bundlha.in',
'1637501@bundlha.in',
'1638320@bundlha.in',
'1638442@bundlha.in',
'1639663@bundlha.in',
'1640614@bundlha.in',
'1641530@bundlha.in',
'1641831@bundlha.in',
'1642800@bundlha.in',
'1643456@bundlha.in',
'1643450@bundlha.in',
'1643588@bundlha.in',
'1643653@bundlha.in',
'1643652@bundlha.in',
'1643753@bundlha.in',
'1643784@bundlha.in',
'1643891@bundlha.in',
'1643913@bundlha.in',
'1643908@bundlha.in',
'1644859@bundlha.in',
'1645310@bundlha.in',
'1645465@bundlha.in',
'1645501@bundlha.in',
'1645528@bundlha.in',
'1645596@bundlha.in',
'1645626@bundlha.in',
'1646154@bundle.com'))))

 update  mpd 
			set mpd.IsUtilized='Y' ,mpd.IsActive='Y' ,mpd.AppointmentId=apt.AppointmentId,
			mpd.UpdatedBy='EXECEL',mpd.UpdatedDate=getdate() 
			from memberplanDetails mpd
			join MemberPlan mp on mp.MemberPlanId=mpd.MemberPlanId
			join Appointment apt on apt.MemberId=mp.MemberId
			where mpd.MemberPlanDetailsId in (718368248,718368249,718368250,718368251,718368252,718368253,718368254,718368255,
			718368256,718368257,718368258,718368259,718368260,718368262,50313576,50313574,
			50313618,50313628,50313674,50313687,50313686,50313685,50313691,50313689,50313688,
			50313705,50313714,50313719,50313734,50313730,50313739,50313743,
			50313568,50313754,50313760,50313813,50313818,50313831,
			50313871,50313870,50313877,50313891,50313890,50313902
			,50313913,50313921,50313925,50313922,50314167,50314160,50314146,50314142,50314133,
			50314110,50314052) 
			and mpd.facilityid=1294 and  mpd.IsUtilized='N' and  mpd.IsActive='Y' and  mpd.Credit='Y';

SELECT * FROM MemberPlan where MemberId in (3051001
,3051000
,3050999
,3050998
,3050997
,3050996
,3050995
,3050981
,3050980
,3050979
,3050978
,3042779
,3042778) and CorporatePlanId=1992 
SELECT * FROM MemberPlanDetails where MemberPlanId in (6481416,6481417
,6489867
,6489868
,6489869
,6489870
,6489875
,6489876
,6489877
,6489878
,6489879
,6489880
,6489881) And MemberId=3042778

select * from CorporatePlan where CorporatePlanId=1992

SELECT * FROM UserLogin where userName='HSHR1985@zepto.com'

select * from MemberPlanDetails where MemberPlanId=6572341
Select * from Member Where userLoginId=5015929
select * from Member where Memberid=3042778
SELECT * FROM UserLogin where UserLoginId=5008204
SELECT * FROM MemberPlan where MemberId=3051001
SELECT * FROM MemberPlanDetails where MemberPlanId=6489881



DECLARE @ServiceType VARCHAR(200),@NewFacilityGroup VARCHAR(100),@ServiceFacilityId BIGINT,@serviceFlag bigint=0;
		  SET @serviceFlag=0;
		  DECLARE @AvailableCreditCount bigint = (SELECT count (mem.facilityid) from  memberplanDetails  mem 
                                                      join memberplan mp on mem.memberplanid=mp.MemberPlanId
                                       				  join member m on m.MemberId=mp.MemberId
                                       				  join userlogin u on u.UserLoginId=m.UserLoginId
                                       			 WHERE u.userloginid=5008204 and mem.FacilityId=4861 and mem.IsUtilized='N' and mem.IsActive='Y' and Credit='Y');
		  PRINT @AvailableCreditCount; 

		  IF @AvailableCreditCount = 0
            BEGIN
            SELECT @ServiceType = ServiceType From FacilitiesMaster where FacilityId=4861
	        print '@ServiceType'
	        print @ServiceType
	        IF @ServiceType='SUBSERVICE'
	           BEGIN
		       SELECT @NewFacilityGroup = FacilityGroup From FacilitiesMaster where FacilityId=4861
		       print 'Facilitygropu'
		       print @NewFacilityGroup

		       SELECT @ServiceFacilityId = FacilityId From FacilitiesMaster Where FacilityGroup=@NewFacilityGroup and ServiceType='SERVICE'
		  print'@ServiceFacilityId'
		  print @ServiceFacilityId

		  IF @ServiceFacilityId is not null or isnull( @ServiceFacilityId,0)!=0
		   begin
		     SET @serviceFlag=1;
		   end

		  SELECT @AvailableCreditCount =  count (mem.facilityid) from  memberplanDetails  mem 
                                                      join memberplan mp on mem.memberplanid=mp.MemberPlanId
                                       				  join member m on m.MemberId=mp.MemberId
                                       				  join userlogin u on u.UserLoginId=m.UserLoginId
                                       			 WHERE u.userloginid=5008204 and mem.FacilityId=@ServiceFacilityId and mem.IsUtilized='N' and mem.IsActive='Y' and Credit='Y';
          print '@AvailableCreditCount'

          PRINT @AvailableCreditCount;
		  

		 
		  
		END
	 
   END


   select * from MemberPlanDetails where MemberPlanId=6572341


Select * from Member Where userLoginId=5015929
select * from Member where Memberid=3051001
SELECT * FROM UserLogin where UserLoginId=5015929
SELECT * FROM MemberPlan where MemberId=3042778
select * from CorporatePlan where CorporatePlanId=1992
SELECT * FROM MemberPlanDetails where MemberPlanId=6481416
SELECT * FROM MemberPlanDetails where MemberPlanDetailsId=718344462

Update MemberPlanDetails set IsUtilized='N' , AppointmentId=null where MemberPlanDetailsId=718344462