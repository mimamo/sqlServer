USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDLY_init]    Script Date: 12/21/2015 15:43:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDLY_init]
as
select * from PJLABDLY
where    docnbr     =  'Z'
	 and	ldl_siteid = 'Z'
	 and	linenbr = 9
GO
