USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTRAN_Init]    Script Date: 12/16/2015 15:55:22 ******/
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
