USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTRAN_Init]    Script Date: 12/21/2015 14:34:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[GLTRAN_Init]
as
select * from GLTRAN
where Module = 'Z'
and BatNbr = 'Z'
and LineNbr = 9
GO
