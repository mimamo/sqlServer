USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTRAN_Init]    Script Date: 12/21/2015 14:34:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APTRAN_Init]
as
select * from APTRAN
where batnbr = 'Z'
and refnbr = 'Z'
and linenbr = 0
GO
