USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[BATCH_Init]    Script Date: 12/21/2015 13:44:46 ******/
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
