USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDOC_Init]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APDOC_Init]
as
select * from APDOC
where batnbr = 'Z'
and refnbr = 'Z'
GO
