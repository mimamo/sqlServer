USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARSETUP_SPK0]    Script Date: 12/21/2015 14:17:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARSETUP_SPK0] as
select * from ARSETUP
where    setupid = 'AR'
order by setupid
GO
