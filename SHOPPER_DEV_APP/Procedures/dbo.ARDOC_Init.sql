USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_Init]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARDOC_Init]
as
select * from ARDOC
where custid = 'Z'
and doctype = 'Z'
and refnbr = 'Z'
and batnbr = 'Z'
and batseq = 9
GO
