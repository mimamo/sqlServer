USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBMIT_salert]    Script Date: 12/21/2015 15:43:04 ******/
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
