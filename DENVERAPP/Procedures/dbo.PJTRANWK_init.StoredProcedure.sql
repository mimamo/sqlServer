USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANWK_init]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANWK_init]
as
select * from PJTRANWK
where
ALLOC_BATCH     = 'Z' and
FISCALNO        = 'Z' and
SYSTEM_CD       = 'Z' and
BATCH_ID        = 'Z' and
PROJECT         = 'Z' and
DETAIL_NUM      = 9
GO
