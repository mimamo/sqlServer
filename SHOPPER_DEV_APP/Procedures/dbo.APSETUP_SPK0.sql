USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APSETUP_SPK0]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APSETUP_SPK0] as
select * from APSETUP
order by setupid
GO
