USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_spk1]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_spk1]
as
select * from PJTRAN
where FISCALNO        = 'Z' and
SYSTEM_CD       = 'Z' and
BATCH_ID        = 'Z' and
DETAIL_NUM      = 9
GO
