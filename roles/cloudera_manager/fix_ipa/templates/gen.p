--- gen.orig	2023-09-19 00:17:14.950431672 -0700
+++ gen.patched	2023-09-19 02:39:21.182151958 -0700
@@ -39,6 +39,8 @@
 # principal name and host.
 PRINC=${PRINCIPAL%%/*}
 HOST=`echo $PRINCIPAL | cut -d "/" -f 2 | cut -d "@" -f 1`
+SERVICE_NAME=`echo $PRINCIPAL | cut -d "/" -f 1 | cut -d "@" -f 1`
+SERVICE_AND_HOST=`echo $PRINCIPAL | cut -d "@" -f 1`
 
 # Create the host if needed.
 set +e
@@ -49,7 +51,11 @@
   echo "Host $HOST exists"
 else
   echo "Adding new host: $HOST"
-  ipa host-add $HOST --force --no-reverse
+  if [[ $HOST =~ \. ]]; then
+    ipa host-add $HOST --force --no-reverse
+  else 
+    ipa host-add $HOST.{{ cluster_name }}  --force --no-reverse
+  fi
 fi
 
 set +e
@@ -62,7 +68,11 @@
 else
   PRINC_EXISTS=no
   echo "Adding new principal: $PRINCIPAL"
-  ipa service-add $PRINCIPAL --force
+  if [[ $SERVICE_AND_HOST =~ \. ]]; then
+    ipa service-add $PRINCIPAL --force
+  else
+    ipa service-add $SERVICE_AND_HOST.{{ cluster_name }} --force
+  fi
 fi
 
 # Set the maxrenewlife for the principal, if given. There is no interface
@@ -110,4 +120,4 @@
 fi
 
 kdestroy
-exit 0
\ No newline at end of file
+exit 0
