USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_ItemBMIHist]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_ItemBMIHist]  @siteid varchar(10), @invtid varchar(30),@fiscyr char(6) as      
select * from itemBMIHist where 
siteid = @siteid 
and invtid = @invtid
and fiscyr = @fiscyr
order by siteid
GO
