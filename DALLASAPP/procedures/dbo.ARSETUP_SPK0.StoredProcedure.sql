USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARSETUP_SPK0]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARSETUP_SPK0] as
select * from ARSETUP
where    setupid = 'AR'
order by setupid
GO
