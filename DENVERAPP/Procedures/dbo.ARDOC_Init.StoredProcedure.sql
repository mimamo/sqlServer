USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_Init]    Script Date: 12/21/2015 15:42:43 ******/
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
