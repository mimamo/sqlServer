USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBMIT_salert]    Script Date: 12/21/2015 14:17:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBMIT_salert]
as
select * from PJSUBMIT
where    status1 = 'O' and
alert_type <> 'N'
GO
