USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BATCH_Init]    Script Date: 12/21/2015 14:17:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[BATCH_Init]
as
select * from BATCH
where module = 'Z'
and batnbr = 'Z'
GO
