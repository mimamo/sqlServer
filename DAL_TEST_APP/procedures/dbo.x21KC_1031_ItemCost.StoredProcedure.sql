USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_ItemCost]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_ItemCost]  @siteid varchar(10), @invtid varchar(30),@layertype varchar(2), @specificcostid varchar(25), @rcptnbr varchar(15), @rcptdate smalldatetime as 
select * from itemCost where 
siteid = @siteid 
and invtid = @invtid
and layertype = @layertype
and specificcostid = @specificcostid
and rcptnbr = @rcptnbr
and rcptdate = @rcptdate
order by siteid
GO
