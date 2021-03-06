USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xtmpValidStudioAgencyFunction]    Script Date: 12/21/2015 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Todd Olson
-- Create date: 9/15/2006
-- Description:	Check validity of Studio/Agency Function Cross-Reference
-- =============================================
CREATE PROCEDURE [dbo].[xtmpValidStudioAgencyFunction] 
	-- Add the parameters for the stored procedure here
	@project varchar(16)
AS
BEGIN

	declare
		@retVal as smallint,
		@retMsg as char(100),
		@APSFncSalesTax	char(30),
		@APSFncValueAdd	char(30),
		@APSFncDiscount	char(30)

	select
		@retVal = 0,
		@retMsg = ' '

	select 	@APSFncSalesTax = control_data	-- 99999
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSSLSTXFUN'

	select 	@APSFncValueAdd = control_data	-- 99990 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSVALADDFUN'

	select 	@APSFncDiscount = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSDISCFUN'

	select top 1
		@retVal = case when
						(at.pjt_entity is null or f.code_id is null) then 1
											  else 0 end,
		@retMsg = case 
					when
						f.code_id is null then 'Studio Function: "' + rtrim(x.studio_pjt_entity) + '" is not found in xIGFunctionCode Table."'
					when
						(at.pjt_entity is null and f.user05 = ' ') then 'Studio Function: "' + rtrim(x.studio_pjt_entity) + ' not mapped to any function in Agency Job: "' + rtrim(s.pm_id34) + '"'
					when
						(at.pjt_entity is null and f.user05 != ' ') then 'Studio Function: "' + rtrim(x.studio_pjt_entity) + ' not mapped to a valid function in Agency Job: "' + rtrim(s.pm_id34) + '"'
											  else ' ' end
	from 
		xtmpAPSXFer as x
			join pjproj as s on x.studio_project = s.project
			join pjproj as a on s.pm_id34 = a.project
			join pjpent as sa on s.project = sa.project and sa.pjt_entity = x.studio_pjt_entity
			left outer join xigfunctioncode as f on sa.pjt_entity = f.code_id
				left outer join pjpent as at on a.project = at.project and f.user05 = at.pjt_entity
	where 
		x.studio_pjt_entity not in (@APSFncSalesTax,@APSFncValueAdd,@APSFncDiscount) and 
		s.project = @project and
		s.pm_id34 != ' ' and
		at.pjt_entity is null

	select
		@retVal,
		@retMsg

END
GO
