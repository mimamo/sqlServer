USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARSETUP_SPK0]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARSETUP_SPK0] as
select * from ARSETUP
where    setupid = 'AR'
order by setupid
GO
