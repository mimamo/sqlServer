USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1025_ValMthdStkItem]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1025_ValMthdStkItem] @invtid1 varchar(30),@invtid2 varchar(30) as
select count(*) from inventory i1, inventory i2
where i1.invtid = @invtid1
and i2.invtid = @invtid2
and ((i1.stkitem <> i2.stkitem) or (i1.valmthd <> i2.valmthd) )
GO
