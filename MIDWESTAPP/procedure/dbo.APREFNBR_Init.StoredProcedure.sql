USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[APREFNBR_Init]    Script Date: 12/21/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APREFNBR_Init]
as
select * from APREFNBR
WHERE refnbr = 'Z'
GO
