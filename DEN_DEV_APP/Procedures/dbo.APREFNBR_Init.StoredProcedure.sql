USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APREFNBR_Init]    Script Date: 12/21/2015 14:05:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APREFNBR_Init]
as
select * from APREFNBR
WHERE refnbr = 'Z'
GO
