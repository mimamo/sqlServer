USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_spk0]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_spk0]  @parm1 varchar (10)   as
select * from PJEXPDET
where    pjexpdet.docnbr     =  @parm1
order by pjexpdet.docnbr, pjexpdet.linenbr
GO
