USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTRAN_Init]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARTRAN_Init]
as
select * from ARTRAN
where custid = 'Z'
and trantype = 'Z'
and refnbr = 'Z'
and linenbr = 9
GO
