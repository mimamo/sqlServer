USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_sIK0]    Script Date: 12/16/2015 15:55:27 ******/
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
