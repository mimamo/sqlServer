USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[APSETUP_SPK0]    Script Date: 12/21/2015 13:44:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APSETUP_SPK0] as
select * from APSETUP
order by setupid
GO
