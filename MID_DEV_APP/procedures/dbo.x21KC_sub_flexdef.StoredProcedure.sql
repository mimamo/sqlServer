USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_sub_flexdef]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_sub_flexdef]  as
select numbersegments, seglength00, seglength01, seglength02, seglength03, seglength04, seglength05, seglength06, seglength07, seperator00, seperator01, seperator02, seperator03, seperator04, seperator05, seperator06  
from flexdef where fieldclassname = 'subaccount'
GO
