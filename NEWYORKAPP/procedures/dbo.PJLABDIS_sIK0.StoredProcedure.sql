USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_sIK0]    Script Date: 12/21/2015 16:01:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDIS_sIK0] as
select * from PJLABDIS
where docnbr = 'Z'
and hrs_type = 'Z'
and linenbr = 9
and status_2 = 'Z'
GO
