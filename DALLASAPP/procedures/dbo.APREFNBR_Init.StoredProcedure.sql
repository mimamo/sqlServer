USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[APREFNBR_Init]    Script Date: 12/21/2015 13:44:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APREFNBR_Init]
as
select * from APREFNBR
WHERE refnbr = 'Z'
GO
