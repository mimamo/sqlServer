USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PCSETUP_SPK0]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PCSETUP_SPK0] as
select * from PCSETUP
order by setupid
GO
