USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANEX_spk1]    Script Date: 12/21/2015 14:06:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANEX_spk1]
as
select * from PJTRANEX
where FISCALNO        = 'Z' and
SYSTEM_CD       = 'Z' and
BATCH_ID        = 'Z' and
DETAIL_NUM      = 9
GO
