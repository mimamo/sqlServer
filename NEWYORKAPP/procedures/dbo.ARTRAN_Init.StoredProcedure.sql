USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARTRAN_Init]    Script Date: 12/21/2015 16:00:50 ******/
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
